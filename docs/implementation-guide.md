# Nix Configuration Implementation Guide

This document contains implementation details and recurring patterns that support the architecture in `architecture.md`. It is intentionally more operational than the ARD. Architectural decisions belong in the ARD; this guide should explain implementation mechanics, examples, and recurring techniques rather than restate those decisions.

## 1. Guiding Principles

Use these principles when making architectural decisions or introducing new configuration. They are deliberately higher-level than the concrete patterns below.

1. **Model capabilities, not implementation mechanisms.**
   Features represent meaningful capabilities such as `git`, `docker`, or `http`, rather than arbitrary installation groupings.

2. **Compose from the bottom up.**
   Keep the dependency direction `feature → feature`, `profile → feature/profile`, `host/home → profile/feature/user`. Lower layers must not depend on higher-level compositions.

3. **Separate reusable configuration from concrete entry points.**
   Features, profiles, users, and factories provide reusable building blocks; hosts and homes are concrete configurations.

4. **Keep ownership explicit.**
   Every piece of configuration should have an obvious owner. Capability-specific packages and settings belong with the capability that gives them meaning.

5. **Prefer composition over inheritance and implicit magic.**
   Build environments by importing modules and composing profiles rather than creating deep inheritance schemes or hidden coupling.

6. **Make direct dependencies explicit.**
   A module should import what it directly requires, even when that dependency also arrives transitively through another module.

7. **Treat repeated and diamond imports as normal.**
   Do not introduce abstractions merely to eliminate repeated reachability. The important question is whether conflicting option definitions exist.

8. **Keep native concepts in native options.**
   When NixOS, nix-darwin, Home Manager, or another module system already provides the appropriate option, use it rather than inventing a parallel configuration mechanism.

9. **Keep abstraction boundaries clean.**
   Plain helpers belong in `lib/`; flake-parts infrastructure in `modules/flake/`; modules in `modules/`; generators in `modules/factories/`; packages in `pkgs/`; encrypted data in `secrets/`.

10. **Prefer one canonical source of truth.**
    Avoid independently maintained representations of the same configuration or package universe when one canonical value can be reused.

11. **Optimize for clarity before deduplication.**
    Small amounts of repeated evaluation or configuration are preferable to clever abstractions whose only purpose is removing duplication.

12. **Make optionality explicit.**
    Model optional data as optional (`nullOr`, `mkIf`, etc.) instead of relying on undefined attributes or implicit fallbacks that can silently produce invalid configuration.

13. **Use abstractions only when they solve a real problem.**
    A helper should encapsulate a reusable transformation; a factory should encapsulate parameterized configuration generation. Do not abstract merely because repetition exists.

14. **Keep context and trust boundaries visible.**
    Dependencies such as `self`, `pkgs`, and configuration context should be explicit when they matter, and secrets should be organized around who owns or can decrypt them.

The overarching test is:

> **Make the dependency, ownership, and scope of every piece of configuration obvious from the structure of the code.**

## 2. Flake-parts Layout

`modules/flake/` contains modules that define flake-level infrastructure or concrete outputs. The ARD defines which responsibilities belong here; this section covers how to implement that boundary.

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

The concrete outputs remain here because they define `flake.darwinConfigurations`, `flake.homeConfigurations`, `flake.packages`, etc. The actual machine/home modules remain under `modules/hosts` and `modules/homes`.

This file is also the boundary between reusable configuration modules and concrete flake configuration outputs.

### Automatic module discovery

The repository imports the whole `modules/` tree from `flake.nix` using `import-tree`:

```nix
(import-tree ./modules)
```

This means individual files under `modules/` are discovered automatically and should not be manually imported from `flake.nix`. Adding a new module file in the tree is enough to make it available to flake-parts. Consequently, `modules/` is reserved for files that are valid flake-parts modules; plain helper code belongs in `lib/`, package definitions in `pkgs/`, and encrypted data in `secrets/`.

## 3. Custom Packages and Overlay

A typical `modules/flake/packages.nix` exposes the custom package tree and overlay:

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

The same `pkgs/` tree is consequently available as:

```text
self.packages.<system>.<name>
self.overlays.default
```

Calling `callPackage` through both paths is acceptable. It represents separate evaluation contexts, not duplicate builds.

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

This makes the custom overlay available to all `perSystem` consumers.

Do not assume that this automatically changes the package set inside NixOS, nix-darwin, or standalone Home Manager. Those configurations need to consume the canonical package set explicitly.

## 5. `moduleWithSystem` vs `withSystem`

Use `moduleWithSystem` when defining a reusable module that needs `perSystem` context:

```nix
flake.modules.darwin.nixpkgs =
  moduleWithSystem ({ pkgs, ... }: {
    nixpkgs.pkgs = pkgs;
  });
```

Use `withSystem` when constructing a concrete flake output:

```nix
homeConfigurations."dp@mbp-private" =
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
    modules = [ self.modules.homeManager."dp@mbp-private" ];
  };
```

Rule:

```text
reusable module + perSystem context → moduleWithSystem
concrete flake output + perSystem context → withSystem
```

`perSystem.pkgs` is not automatically propagated into NixOS, nix-darwin, or standalone Home Manager; concrete configuration construction must explicitly reuse it.

## 6. `readOnlyPkgs`

For NixOS, when the system should use the canonical externally constructed package set, include the NixOS `readOnlyPkgs` module and assign the canonical `pkgs` to `nixpkgs.pkgs`.

Do not reuse that NixOS module for nix-darwin or Home Manager.

For integrated Home Manager under nix-darwin/NixOS, `home-manager.useGlobalPkgs = true` can reuse the system package set.

## 7. Configuration Outputs

Keep concrete configuration output construction in `modules/flake/configurations.nix` while it remains manageable.

For standalone HM, pass the correct system-specific canonical `pkgs` to `homeManagerConfiguration`.

For Darwin/NixOS, inject the canonical package set into the system module graph.

The `modules/hosts/` and `modules/homes/` modules themselves should remain class-pure:

```text
hosts/* → darwin/nixos modules
homes/* → homeManager modules
```

## 8. Generic Context

The ARD defines the role of generic context. At implementation level, `modules/features/meta.nix` can define class-independent options such as:

```nix
meta.user.name
meta.user.fullName
meta.user.email
```

A feature that consumes those options should import the provider:

```nix
imports = [
  self.modules.generic.meta
];
```

Keep the namespace typed and structured. Generic context is for shared information, not a replacement for feature options.

## 9. Custom Library

Root `lib/default.nix` is the top-level namespace of the project library:

```nix
{
  secrets = import ./secrets.nix;
  packages = import ./packages.nix;
}
```

Expose it from `modules/flake/lib.nix`:

```nix
{ ... }: {
  flake.lib.my = import ../../lib;
}
```

Then `modules/features/my-lib.nix` injects it into module graphs:

```nix
{ self, ... }: {
  flake.modules.generic.my-lib = {
    _module.args.myLib = self.lib.my;
  };
}
```

Import `self.modules.generic.my-lib` from the appropriate base profile(s), rather than repeating it in every feature.

Inside modules:

```nix
{ lib, myLib, ... }:
```

Keep standard `lib` and project `myLib` separate.

### Library design

Keep ordinary library functions as context-independent as practical. Pass dependencies explicitly:

```nix
{
  packageExists = pkgs: name:
    builtins.hasAttr name pkgs;
}
```

Avoid making the entire library implicitly depend on `self`, `pkgs`, or a particular system unless that context is genuinely intrinsic.

## 10. Factories

Dendritic factories generate configuration rather than merely calculating values.

Factory implementations belong under `modules/factories/` when they need flake-parts context such as `self`, `lib`, or `moduleWithSystem`. Keeping them as flake-parts modules also avoids having to thread that context manually through a plain `lib/` function.

`modules/flake/factory.nix` defines the shared, option-backed `flake.factory.*` registry. The option is useful because individual factory modules can contribute independently to one namespace while retaining access to the flake-parts module context. This is distinct from `self.modules.*`, which stores ready-to-use modules.

Conceptual factory:

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
    imports = [ self.modules.generic.meta ];
    meta.user = user;

    config = lib.mkIf isPrimary {
      system.primaryUser = name;
    };
  };

  homeManager.${name} = {
    imports = [ self.modules.generic.meta ];
    meta.user = user;
    home.username = name;
  };
};
```

The important output shape is:

```nix
{
  darwin.dp = { ... };
  homeManager.dp = { ... };
}
```

which can be merged directly:

```nix
flake.modules = lib.mkMerge [
  (self.factory.user {
    name = "dp";
    fullName = "Damian Example";
    isPrimary = true;
  })
];
```

### Factory vs library

Use `myLib` when the result is a value/transformation:

```nix
myLib.secrets.someHelper ...
```

Use `self.factory.*` when the result is configuration:

```nix
self.factory.user { ... }
```

## 11. User Modules with the Factory

`modules/users/dp.nix` becomes a concrete user instance of the generic factory; it supplies the concrete identity while the factory supplies the shared Darwin/Home Manager structure.

Conceptually:

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

The user file may additionally extend the generated modules with user-specific exceptions.

`isPrimary` is preferred over `isAdmin` because it controls `system.primaryUser`, not general administrative privileges.

## 12. Conditional User Data

Optional user email should be represented as `null`, not as an undefined option:

```nix
email ? null
```

and the corresponding `meta.user.email` option should normally be typed as:

```nix
lib.types.nullOr lib.types.str
```

with:

```nix
default = null;
```

This permits safe tests such as:

```nix
lib.mkIf (config.meta.user.email != null) { ... }
```

## 13. SOPS

The ARD defines the secret ownership model. This section covers the implementation pattern for wiring SOPS into modules. The SOPS feature configures the SOPS-nix integration and Age key location; it does not own every secret.

### Central credential file

Example:

```nix
sops.secrets.workEmail = {
  sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";
  key = "work/email";
};
```

The Nix identifier and YAML key are independent.

### Feature-owned encrypted config

For an application whose encrypted configuration is intrinsically part of the feature:

```text
modules/features/organize-tool/
├── default.nix
└── config.sops.yaml
```

Use the feature-local file with `./config.sops.yaml`.

### Git secret consumption

Prefer:

```text
home
  → declares workEmail

git feature
  → conditionally renders the Git include/template
```

instead of coupling the concrete home module to `programs.git.includes`.

## 14. SOPS File Organization

Recommended model:

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

Use one file per host/home/service domain. Keep related keys together and use nested YAML paths when useful.

The current recipient model allows a machine Age identity to decrypt all secrets associated with that machine and all users on it, plus selected shared secrets. A master recipient can recover all encrypted data.

## 15. Path Conventions

For centralized root-level resources, use the flake root:

```nix
self + "/secrets/homes/dp@mbp-positive.yaml"
```

This avoids deep relative paths when modules move between directories.

For a resource intentionally owned by a feature, a local path is appropriate:

```nix
./config.sops.yaml
```

## 16. `nix fmt`

Use the official project-tree wrapper:

```nix
perSystem = { pkgs, ... }: {
  formatter = pkgs.nixfmt-tree;
};
```

This is preferred over configuring plain `nixfmt` as the tree formatter because `nixfmt-tree` is intended to format the project tree used by `nix fmt`.
