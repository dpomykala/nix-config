# Nix configuration implementation guide

This guide shows the mechanics and recurring patterns behind the architecture
doc, [`architecture.md`](architecture.md). The architecture doc records the
rules and the reasons behind them. This guide links to it instead of repeating
them. If the two documents disagree, the architecture doc wins.

## Contents

- [1. Flake-parts layout](#1-flake-parts-layout)
- [2. Custom packages and overlay](#2-custom-packages-and-overlay)
- [3. Canonical `perSystem.pkgs`](#3-canonical-persystempkgs)
- [4. `moduleWithSystem` or `withSystem`](#4-modulewithsystem-or-withsystem)
- [5. `readOnlyPkgs`](#5-readonlypkgs)
- [6. Configuration outputs](#6-configuration-outputs)
- [7. Generic context](#7-generic-context)
- [8. Custom library](#8-custom-library)
- [9. Factories](#9-factories)
- [10. User modules with the factory](#10-user-modules-with-the-factory)
- [11. Conditional user data](#11-conditional-user-data)
- [12. SOPS](#12-sops)
- [13. Path conventions](#13-path-conventions)
- [14. `nix fmt`](#14-nix-fmt)
- [15. Common tasks](#15-common-tasks)

## 1. Flake-parts layout

`modules/flake/` contains modules that define flake-level infrastructure or
concrete outputs. [`architecture.md` §1, *Repository
structure*](architecture.md#1-repository-structure), defines which
responsibilities belong here.

```text
modules/flake/
├── configurations.nix
├── devshells.nix
├── factory.nix
├── formatter.nix
├── lib.nix
├── nixpkgs.nix
└── packages.nix
```

The concrete outputs live here because these files define
`flake.darwinConfigurations`, `flake.homeConfigurations`, `flake.packages`, and
other outputs. The machine and home modules themselves live in `modules/hosts/`
and `modules/homes/`.

This directory is the boundary between reusable configuration modules and
concrete flake outputs.

### Automatic module discovery

`flake.nix` imports the whole `modules/` tree with `import-tree`, as
[`architecture.md` §1, *Repository
structure*](architecture.md#1-repository-structure), describes. `flake.nix` also
imports two flake modules that declare options the modules under `modules/` rely
on: `flake-parts.flakeModules.modules` declares `flake.modules`, and
`home-manager.flakeModules.home-manager` declares `flake.homeConfigurations`.

## 2. Custom packages and overlay

`modules/flake/packages.nix` exposes the custom package tree and the overlay:

```nix
_: {
  flake.overlays.default = final: prev:
    prev.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ../../pkgs;
    };

  perSystem = { pkgs, ... }: {
    packages = pkgs.lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ../../pkgs;
    };
  };
}
```

The same `pkgs/` tree is then available as:

```text
self.packages.<system>.<name>
self.overlays.default
```

Both paths call `callPackage` on the same package definitions. They produce the
same derivation, so Nix builds each package only once.

## 3. Canonical `perSystem.pkgs`

Configure `perSystem.pkgs` once:

```nix
{ inputs, self, ... }: {
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;

      overlays = [
        self.overlays.default
      ];
    };
  };
}
```

Every `perSystem` consumer then gets the custom overlay.

Sections 4 to 6 show how each configuration consumes this package set.
[`architecture.md` §5, *Packages and
nixpkgs*](architecture.md#5-packages-and-nixpkgs), explains why they need to.

## 4. `moduleWithSystem` or `withSystem`

Use `moduleWithSystem` to define a reusable module that needs `perSystem`
context:

```nix
flake.modules.darwin.nixpkgs = moduleWithSystem (
  { pkgs, ... }: _: {
    nixpkgs.pkgs = pkgs;
  }
);
```

The outer function receives the `perSystem` arguments, so `pkgs` is the
canonical package set. The inner function is the module itself, and `_` ignores
its module arguments.

Use `withSystem` to construct a concrete flake output:

```nix
homeConfigurations."dp@mbp-private" =
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
    modules = [ self.modules.homeManager."dp@mbp-private" ];
  };
```

### `moduleWithSystem` in nix-darwin host modules

Every host module sets `_module.args.system`. [`architecture.md` §3,
*Composition and dependencies*](architecture.md#3-composition-and-dependencies),
explains the infinite recursion that it prevents. Set it next to
`nixpkgs.hostPlatform`:

```nix
flake.modules.darwin.my-host = {
  nixpkgs.hostPlatform = "aarch64-darwin";
  _module.args = { system = "aarch64-darwin"; };
};
```

## 5. `readOnlyPkgs`

To make a NixOS system use the canonical package set, import the NixOS
`readOnlyPkgs` module and assign the set to `nixpkgs.pkgs`.
`modules/features/nixpkgs.nix` contains a commented-out NixOS example.

Don't reuse that NixOS module for nix-darwin or Home Manager. It redeclares the
`nixpkgs.*` options, so both nix-darwin and Home Manager fail with an "option is
already declared" error.

For Home Manager integrated into nix-darwin or NixOS,
`home-manager.useGlobalPkgs = true` reuses the system package set.

## 6. Configuration outputs

Build the concrete configuration outputs in `modules/flake/configurations.nix`
while the file stays manageable.

For standalone Home Manager, pass the canonical package set for the target
system to `homeManagerConfiguration`.

For nix-darwin, inject the canonical package set into the system module tree
through the `nixpkgs` feature in `modules/features/nixpkgs.nix`. The NixOS
variant in that file is commented out until a NixOS host exists.

Keep each module in `modules/hosts/` and `modules/homes/` to one class:

```text
hosts/* → darwin/nixos modules
homes/* → homeManager modules
```

## 7. Generic context

[`architecture.md` §6, *Generic context and custom
library*](architecture.md#6-generic-context-and-custom-library), defines the
role of generic context. In this repository, `modules/features/meta.nix` defines
these class-independent options:

```nix
meta.user.name
meta.user.fullName
meta.user.email
```

The `meta` module declares options with `lib.mkOption`, so import it exactly
once per module tree. Import it from the base profile, not from individual
features:

```nix
# In a profile (base.nix)
flake.modules.darwin.base = {
  imports = [
    self.modules.generic.meta
  ];
};

# In a feature, use the options without importing meta
flake.modules.darwin.foo = { config, lib, ... }: {
  config = lib.mkIf (config.meta.user.email != null) {
    # ...
  };
};
```

Keep the namespace typed and structured. Generic context holds shared
information. It doesn't replace feature options.

## 8. Custom library

Root `lib/default.nix` is the top-level namespace of the project library. The
library is empty today. To expose a helper submodule, import it under a
namespace, for example:

```nix
{
  secrets = import ./secrets.nix;
  packages = import ./packages.nix;
}
```

`modules/flake/lib.nix` exposes the library as a flake output:

```nix
{ self, ... }: {
  # Expose the custom lib as a flake output
  flake.lib.my = import (self + "/lib");
}
```

`modules/features/my-lib.nix` then injects the library into module trees:

```nix
{ self, ... }: {
  flake.modules.generic.my-lib = {
    _module.args.myLib = self.lib.my;
  };
}
```

Modules then take `myLib` as an argument:

```nix
{ lib, myLib, ... }:
```

### Library design

To keep a helper independent of context, as [`architecture.md` §6, *Generic
context and custom
library*](architecture.md#6-generic-context-and-custom-library) requires, pass
its dependencies as arguments:

```nix
{
  packageExists = pkgs: name:
    builtins.hasAttr name pkgs;
}
```

## 9. Factories

[`architecture.md` §7, *Factories*](architecture.md#7-factories), defines what a
factory is, when to use one instead of a `myLib` function, and why the
`flake.factory.*` registry is an option.

`modules/factories/user.nix` defines the `user` factory:

```nix
flake.factory.user = {
  name,
  fullName,
  email ? null,
  isPrimary ? false,
}: let
  user = { inherit name fullName email; };
in {
  darwin.${name} = { lib, ... }: {
    meta.user = user;

    config = lib.mkIf isPrimary {
      system.primaryUser = name;
    };
  };

  homeManager.${name} = {
    meta.user = user;
    home.username = name;
  };
};
```

The output has this shape:

```nix
{
  darwin.dp = { ... };
  homeManager.dp = { ... };
}
```

This shape merges directly into `flake.modules`:

```nix
flake.modules = lib.mkMerge [
  (self.factory.user {
    name = "dp";
    fullName = "Damian Example";
    isPrimary = true;
  })
];
```

## 10. User modules with the factory

`modules/users/dp.nix` is a concrete user built with the generic factory. The
file supplies the identity of the user, and the factory supplies the shared
Darwin and Home Manager structure.

In simplified form:

```nix
{ self, ... }: {
  flake.modules = self.factory.user {
    name = "dp";
    fullName = "Damian Example";
    email = "damian@example.com";
    isPrimary = true;
  };
}
```

A user file can also extend the generated modules with user-specific
exceptions:

```nix
{ self, lib, ... }: {
  flake.modules = lib.mkMerge [
    (self.factory.user {
      name = "dp";
      fullName = "Damian Example";
    })
    # User-specific exceptions:
    # { homeManager.dp = { ... }; }
  ];
}
```

The factory uses `isPrimary`, not `isAdmin`, because the flag controls
`system.primaryUser`, not general administrator privileges.

## 11. Conditional user data

Represent an optional user email as `null`, not as an undefined option:

```nix
email ? null
```

Give the matching `meta.user.email` option this type:

```nix
lib.types.nullOr lib.types.str
```

Set its default to `null`:

```nix
default = null;
```

Modules can then test the value safely:

```nix
lib.mkIf (config.meta.user.email != null) { ... }
```

## 12. SOPS

[`architecture.md` §8, *Secrets and SOPS*](architecture.md#8-secrets-and-sops),
defines who owns each secret. This section shows how to wire SOPS into modules.
The `sops` feature configures the sops-nix integration and the location of the
age key file. It doesn't own every secret.

### Central credential file

A module declares a secret from a central credential file like this:

```nix
sops.secrets.userEmail = {
  sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";
};
```

`key` defaults to the Nix name. Set it to use a different YAML key, including a
nested path such as `key = "work/email"`.

### Git secret consumption

For configuration that depends on a secret, let the home declare the secret and
let the feature render the configuration:

```text
home
  → declares userEmail

git feature
  → conditionally renders the Git include/template
```

Don't make the home module use SOPS template mechanics directly.

A home can set `programs.git.includes` directly for plain overrides that
contain no secret and apply only to that home, such as a per-repository
identity. Use inline `contents` for these overrides. The `git` feature adds its
own includes with `lib.mkBefore`, so includes from a home come later and
override them within their scope.

## 13. Path conventions

For a central resource at the repository root, build the path from the flake
root:

```nix
self + "/secrets/homes/dp@mbp-positive.yaml"
```

This path keeps working when a module moves to another directory, and it avoids
deep relative paths.

For a resource that a feature owns, use a local path:

```nix
./config.sops.yaml
```

## 14. `nix fmt`

`modules/flake/formatter.nix` sets the official tree wrapper as the formatter:

```nix
perSystem = { pkgs, ... }: {
  formatter = pkgs.nixfmt-tree;
};
```

Use `nixfmt-tree`, not plain `nixfmt`. Plain `nixfmt` formats only the files
that it receives. `nixfmt-tree` wraps treefmt, so `nix fmt` with no arguments
formats every Nix file in the project.

## 15. Common tasks

These checklists cover rare tasks that touch several files. After each task,
stage the new files, format, and evaluate, as [*Verify changes* in
`AGENTS.md`](../AGENTS.md#verify-changes) describes.

### Add a nix-darwin host

1. Get the host name from the user, or run `scutil --get LocalHostName` on the
   target machine. The name must match the output of that command
   ([`architecture.md` §2](architecture.md#2-configuration-layers)).
2. Create `modules/hosts/<host>.nix`, which defines
   `flake.modules.darwin.<host>`. Copy an existing host, such as
   `modules/hosts/mbp-private.nix`.
3. Import `base`, the feature bundles, the features, and one user module. A host
   can import only one user module ([`architecture.md`
   §2](architecture.md#2-configuration-layers)).
4. Set `networking.hostName`, `nixpkgs.hostPlatform`, and `_module.args.system`
   (§4).
5. Add the host to `flake.darwinConfigurations` in
   `modules/flake/configurations.nix`.

### Add a home

1. Get the host name from the user, or run `hostname` on the target machine.
   Name the home `<user>@<host>` ([`architecture.md`
   §2](architecture.md#2-configuration-layers)).
2. Create `modules/homes/<user>@<host>.nix`, which defines
   `flake.modules.homeManager."<user>@<host>"`. Copy an existing home, such as
   `modules/homes/dp@mbp-private.nix`.
3. Import exactly one platform profile, the feature bundles, the features, and
   the user module ([`architecture.md`
   §3](architecture.md#3-composition-and-dependencies)).
4. Add the home to `flake.homeConfigurations` in
   `modules/flake/configurations.nix`. Pass the package set with
   `withSystem "<system>"` (§4).

### Add a user

1. Create `modules/users/<name>.nix`, which calls `self.factory.user` (§10).
2. Set `isPrimary = true` only for the user who becomes `system.primaryUser`.
   The flag applies on every host that imports the user.
3. Import `darwin.<name>` in the host module and `homeManager.<name>` in each
   home of the user. A host can import only one user module ([`architecture.md`
   §2](architecture.md#2-configuration-layers)).

### Add a secret

Only Home Manager has a `sops` feature, and `homeManager.base` imports it, so
only Home Manager modules can use secrets.

1. If the machine has no age key yet, create one at
   `~/.config/sops/age/keys.txt` on that machine. Add its public key and
   creation rules to `.sops.yaml`, as for `mbp-positive`.
2. Choose the file by scope: `secrets/hosts/`, `secrets/homes/`, or
   `secrets/shared/` ([`architecture.md`
   §8](architecture.md#8-secrets-and-sops)). Name the file so that it matches a
   path rule in `.sops.yaml`, such as `secrets/homes/<user>@<host>.yaml`. A file
   that matches no rule gets only the master key.
3. Create or edit the file with `sops <file>`.
4. Declare `sops.secrets.<name>` with `sopsFile = self + "/secrets/..."` in the
   home that needs the secret (§12). A feature doesn't declare credentials. Only
   encrypted configuration that belongs to a feature stays in the feature, with
   a local `sopsFile` ([`architecture.md`
   §8](architecture.md#8-secrets-and-sops)).
5. In a feature that uses the secret, guard the configuration with
   `lib.mkIf (config.sops.secrets ? <name>)` and a fallback, as `git` does with
   `userEmail` ([`architecture.md`
   §3](architecture.md#3-composition-and-dependencies)).
6. Use the secret through `config.sops.secrets.<name>.path` or a
   `config.sops.templates` entry. Never read its value at evaluation time.
