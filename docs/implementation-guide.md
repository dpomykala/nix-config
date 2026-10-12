# Nix configuration implementation guide

This guide covers the implementation details and recurring patterns behind the
architecture decisions in [`architecture.md`](architecture.md), the
Architecture Decision Record (ADR). The ADR records the decisions, and this
guide shows the mechanics with examples. The guide restates some decision-level
rules briefly for context. If the two documents disagree, the ADR wins.

## Contents

- [1. Guiding principles](#1-guiding-principles)
- [2. Flake-parts layout](#2-flake-parts-layout)
- [3. Custom packages and overlay](#3-custom-packages-and-overlay)
- [4. Canonical `perSystem.pkgs`](#4-canonical-persystempkgs)
- [5. `moduleWithSystem` or `withSystem`](#5-modulewithsystem-or-withsystem)
- [6. `readOnlyPkgs`](#6-readonlypkgs)
- [7. Configuration outputs](#7-configuration-outputs)
- [8. Generic context](#8-generic-context)
- [9. Custom library](#9-custom-library)
- [10. Factories](#10-factories)
- [11. User modules with the factory](#11-user-modules-with-the-factory)
- [12. Conditional user data](#12-conditional-user-data)
- [13. SOPS](#13-sops)
- [14. SOPS file organization](#14-sops-file-organization)
- [15. Path conventions](#15-path-conventions)
- [16. `nix fmt`](#16-nix-fmt)

## 1. Guiding principles

Apply these principles when you make an architecture decision or add
configuration. They are more general than the patterns in the later sections.

1. **Model capabilities, not implementation mechanisms.**
   A feature is a meaningful capability such as `git`, `docker`, or `http`, not
   an arbitrary group of packages to install.

2. **Compose from the bottom up.**
   Profiles depend on features and other profiles. Hosts and homes depend on
   profiles, features, and users. Features sit at the bottom. They import no
   other features, only their own wrapped input modules (see the provider rule
   in ADR §3), and they depend only on options. A lower layer never depends on
   a higher-level composition.

3. **Separate reusable configuration from concrete entry points.**
   Features, profiles, users, and factories are reusable building blocks. Hosts
   and homes are concrete configurations.

4. **Keep ownership explicit.**
   Every piece of configuration has one obvious owner. Packages and settings
   that belong to a capability live in the feature for that capability.

5. **Prefer composition over inheritance and hidden coupling.**
   Build environments by importing modules and composing profiles, not through
   deep inheritance chains or hidden coupling.

6. **Compose shared dependencies in profiles, not inside features.**
   A feature module never imports another feature module. Profiles, hosts, or
   homes compose shared dependencies once per module tree. The module system
   can't deduplicate a module value, such as a feature or a profile, that is
   reached twice. Module values are anonymous modules, so the module system
   merges them twice. List values get duplicate entries, and option
   declarations fail with "option is already declared" errors.

7. **Make features self-sufficient with `lib.mkDefault`.**
   If a feature needs a tool enabled, such as `programs.mise` or
   `programs.ssh`, set `enable = lib.mkDefault true` in the feature. The
   feature of the tool sets `enable = true` at normal priority, which takes
   precedence. A profile can override both with `lib.mkForce false`. For a
   dependency that is truly optional, use `lib.mkIf` with a fallback.

8. **Keep native concepts in native options.**
   If NixOS, nix-darwin, Home Manager, or another module system already has the
   right option, use it. Don't invent a parallel mechanism.

9. **Keep abstraction boundaries clean.**
   Each kind of code has one place: plain helpers in `lib/`, flake-parts
   infrastructure in `modules/flake/`, modules in `modules/`, factories in
   `modules/factories/`, packages in `pkgs/`, and encrypted data in `secrets/`.

10. **Prefer one canonical source of truth.**
    Don't maintain two independent representations of the same configuration or
    package set when one canonical value can serve both.

11. **Optimize for clarity before deduplication.**
    A little repeated evaluation or configuration is better than a clever
    abstraction whose only purpose is to remove duplication.

12. **Make optionality explicit.**
    Model optional data as optional, with `nullOr` or `mkIf`. Don't rely on
    undefined attributes or implicit fallbacks, because they can silently
    produce invalid configuration.

13. **Use abstractions only when they solve a real problem.**
    A helper wraps a reusable transformation. A factory wraps parameterized
    configuration generation. Repetition alone is not a reason to abstract.

14. **Keep context and trust boundaries visible.**
    Pass dependencies such as `self`, `pkgs`, and configuration context
    explicitly when they matter. Organize secrets around who owns them and who
    can decrypt them.

One test covers all of these:

> **Make the dependency, ownership, and scope of every piece of configuration
> obvious from the structure of the code.**

## 2. Flake-parts layout

`modules/flake/` contains modules that define flake-level infrastructure or
concrete outputs. ADR §1, *Repository structure*, defines which
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

`flake.nix` imports the whole `modules/` tree with `import-tree`:

```nix
(import-tree ./modules)
```

`import-tree` finds every `.nix` file under `modules/`, so don't import those
files from `flake.nix`. To add a module, create its file in the tree. Because
of this, every `.nix` file under `modules/` must be a valid flake-parts module.
Put plain helper code in `lib/`, package definitions in `pkgs/`, and encrypted
data in `secrets/`.

## 3. Custom packages and overlay

`modules/flake/packages.nix` exposes the custom package tree and the overlay:

```nix
{ ... }: {
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

Both paths call `callPackage`, and that is fine. Each call runs in a separate
evaluation context, and Nix doesn't build the package twice.

## 4. Canonical `perSystem.pkgs`

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

This doesn't change the package set inside NixOS, nix-darwin, or standalone
Home Manager. Those configurations must consume the canonical package set
explicitly.

## 5. `moduleWithSystem` or `withSystem`

Use `moduleWithSystem` to define a reusable module that needs `perSystem`
context:

```nix
flake.modules.darwin.nixpkgs = moduleWithSystem (
  { pkgs, ... }: _: {
    nixpkgs.pkgs = pkgs;
  }
);
```

Use `withSystem` to construct a concrete flake output:

```nix
homeConfigurations."dp@mbp-private" =
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
    modules = [ self.modules.homeManager."dp@mbp-private" ];
  };
```

The rule:

```text
reusable module + perSystem context → moduleWithSystem
concrete flake output + perSystem context → withSystem
```

### `moduleWithSystem` in nix-darwin host modules

`moduleWithSystem` looks for the target system in `config._module.args.system`
first, then falls back to `config._module.args.pkgs`. If a module wrapped in
`moduleWithSystem` sets `nixpkgs.pkgs`, the fallback causes infinite recursion.
To avoid it, set `_module.args.system` in every host module:

```nix
flake.modules.darwin.my-host = {
  nixpkgs.hostPlatform = "aarch64-darwin";
  _module.args = { system = "aarch64-darwin"; };
};
```

## 6. `readOnlyPkgs`

To make a NixOS system use the canonical package set, import the NixOS
`readOnlyPkgs` module and assign the set to `nixpkgs.pkgs`.
`modules/features/nixpkgs.nix` contains a commented-out NixOS example.

Don't reuse that NixOS module for nix-darwin or Home Manager.

For Home Manager integrated into nix-darwin or NixOS,
`home-manager.useGlobalPkgs = true` reuses the system package set.

## 7. Configuration outputs

Build the concrete configuration outputs in `modules/flake/configurations.nix`
while the file stays manageable.

For standalone Home Manager, pass the canonical package set for the target
system to `homeManagerConfiguration`.

For nix-darwin and NixOS, inject the canonical package set into the system
module graph through the `nixpkgs` feature in `modules/features/nixpkgs.nix`.

Keep each module in `modules/hosts/` and `modules/homes/` to one class:

```text
hosts/* → darwin/nixos modules
homes/* → homeManager modules
```

## 8. Generic context

ADR §6, *Generic context and custom library*, defines the role of generic
context. In this repository, `modules/features/meta.nix` defines these
class-independent options:

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

## 9. Custom library

Root `lib/default.nix` is the top-level namespace of the project library. To
expose a helper submodule, import it under a namespace, for example:

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
  flake.lib.my = import self + "/lib";
}
```

`modules/features/my-lib.nix` then injects the library into module graphs:

```nix
{ self, ... }: {
  flake.modules.generic.my-lib = {
    _module.args.myLib = self.lib.my;
  };
}
```

Import `self.modules.generic.my-lib` from the base profiles, not from every
feature.

Modules then take `myLib` as an argument:

```nix
{ lib, myLib, ... }:
```

Keep the standard `lib` and the project `myLib` separate.

### Library design

Keep ordinary library functions as independent of context as practical. Pass
dependencies as arguments:

```nix
{
  packageExists = pkgs: name:
    builtins.hasAttr name pkgs;
}
```

Don't make the whole library depend implicitly on `self`, `pkgs`, or a
particular system, unless a function can't work without that context.

## 10. Factories

A dendritic factory generates configuration. A library function only calculates
values.

Put a factory in `modules/factories/` when it needs flake-parts context such as
`self` or `moduleWithSystem`. As a flake-parts module, the factory gets that
context directly, so you don't have to pass it by hand through a plain `lib/`
function.

`modules/flake/factory.nix` declares the shared `flake.factory.*` registry as
an option. Because the registry is an option, separate factory modules can add
to one namespace and still use the flake-parts module context. In contrast,
`self.modules.*` stores ready-to-use modules.

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

### Factory or library

Use `myLib` when the result is a value or a transformation:

```nix
myLib.secrets.someHelper ...
```

Use `self.factory.*` when the result is configuration:

```nix
self.factory.user { ... }
```

## 11. User modules with the factory

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

## 12. Conditional user data

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

## 13. SOPS

ADR §8, *Secrets and SOPS*, defines who owns each secret. This section shows
how to wire SOPS into modules. The `sops` feature configures the sops-nix
integration and the location of the age key file. It doesn't own every secret.

### Central credential file

A module declares a secret from a central credential file like this:

```nix
sops.secrets.userEmail = {
  sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";
  key = "userEmail";
};
```

The Nix name and the YAML key are independent. `key` can also point at a nested
YAML path, for example `key = "work/email"`.

### Feature-owned encrypted config

If the encrypted configuration of an application is part of the feature, keep
it in the feature directory:

```text
modules/features/organize-tool/
├── default.nix
└── config.sops.yaml
```

Reference the file with the local path `./config.sops.yaml`.

### Git secret consumption

For configuration that depends on a secret, let the home declare the secret and
let the feature render the configuration:

```text
home
  → declares userEmail

git feature
  → conditionally renders the Git include/template
```

Don't make the home module use SOPS template mechanics directly. With this
split, the home doesn't depend on how the `git` feature handles secrets.

A home can set `programs.git.includes` directly for plain overrides that
contain no secret and apply only to that home, such as a per-repository
identity. Use inline `contents` for these overrides. The `git` feature adds its
own includes with `lib.mkBefore`, so includes from a home come later and
override them within their scope.

## 14. SOPS file organization

The recommended layout:

```text
secrets/
├── hosts/
│   └── mbp-positive.yaml
├── homes/
│   └── dp@mbp-positive.yaml
└── shared/
    ├── github.yaml
    └── cloudflare.yaml
```

Only `secrets/homes/` exists today. Add `hosts/` and `shared/` files when you
need them.

Use one file for each host, home, or service domain. Keep related keys
together, and use nested YAML paths where they help.

`.sops.yaml` defines the recipients. The age key of a machine can decrypt the
secrets of that machine, the secrets of every user on it, and everything under
`secrets/shared/`. The master key can decrypt all encrypted data.

## 15. Path conventions

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

## 16. `nix fmt`

`modules/flake/formatter.nix` sets the official tree wrapper as the formatter:

```nix
perSystem = { pkgs, ... }: {
  formatter = pkgs.nixfmt-tree;
};
```

Use `nixfmt-tree`, not plain `nixfmt`. Plain `nixfmt` formats only the files
that it receives. `nixfmt-tree` wraps treefmt, so `nix fmt` with no arguments
formats every Nix file in the project.
