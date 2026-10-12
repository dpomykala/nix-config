# Nix configuration architecture

This document records the architecture decisions for this repository.
[`implementation-guide.md`](implementation-guide.md) shows how to implement
them.

## Contents

- [Summary](#summary)
- [1. Repository structure](#1-repository-structure)
- [2. Configuration layers](#2-configuration-layers)
- [3. Composition and dependencies](#3-composition-and-dependencies)
- [4. Configuration classes and platform
  scope](#4-configuration-classes-and-platform-scope)
- [5. Packages and nixpkgs](#5-packages-and-nixpkgs)
- [6. Generic context and custom
  library](#6-generic-context-and-custom-library)
- [7. Factories](#7-factories)
- [8. Secrets and SOPS](#8-secrets-and-sops)
- [9. Naming and placement rules](#9-naming-and-placement-rules)

## Summary

- The repository uses a feature-oriented dendritic architecture with
  `modules/features/`, `modules/profiles/`, `modules/hosts/`, `modules/homes/`,
  `modules/users/`, and `modules/factories/`. See §1 and §2.
- Keep each kind of file in its own place: flake infrastructure in
  `modules/flake/`, plain helper functions in root `lib/`, custom packages in
  root `pkgs/`, and encrypted data in root `secrets/`. See §1.
- Features provide capabilities, and profiles compose them. Hosts and homes are
  the concrete entry points. Users provide reusable user identity and
  configuration. Factories generate parameterized configuration. See §2.
- System and user environments stay separate. A host is a machine and can have
  several users. A home is one user's standalone Home Manager environment on
  one host. See §2.
- Features don't import features. Profiles, hosts, or homes compose shared
  dependencies once. A feature that needs a tool enables it with
  `lib.mkDefault true`. A feature that can use an optional dependency guards it
  with `lib.mkIf` and a fallback. See §3.
- Platform profiles import `base`, and feature bundles don't. Each home imports
  exactly one platform profile, so no profile is reached twice. See §3.
- Each external input module is imported exactly once, by its provider feature.
  Consumers only set its options. See §3.
- Every host module sets `_module.args.system`, or `moduleWithSystem` recurses
  infinitely. See §3.
- Reusable modules go in `flake.modules.<class>.<name>`. Class-independent
  module context goes in `flake.modules.generic.*`. See §4 and §6.
- Prefer a separate module for each platform over `isLinux` or `isDarwin`
  conditionals. See §4.
- One canonical package set, `perSystem.pkgs`, serves every output. Custom
  packages are exposed through both `self.packages.<system>` and
  `self.overlays.default`. See §5.
- Use `moduleWithSystem` in reusable modules that need `perSystem` context. Use
  `withSystem` to construct concrete flake outputs. On NixOS, use the
  `readOnlyPkgs` module to inject the canonical package set. See §5.
- The standard module `lib` stays unchanged. Project helpers are exposed as
  `self.lib.my`, and `self.modules.generic.my-lib` injects them into module
  trees as `myLib`. See §6.
- `self.factory.*` generates parameterized configuration. Factories that
  generate `flake.modules` live in `modules/factories/`. The factory registry
  is a flake-parts option, so independent factory modules can add to one
  namespace and still use flake-parts context such as `self`. See §7.
- SOPS credentials are grouped by scope: `secrets/hosts`, `secrets/homes`, and
  `secrets/shared`. Encrypted application configuration that belongs to one
  feature can stay next to that feature. See §8.
- Name each feature and factory file after the module it defines. See §9.
- `nixfmt-tree` formats the Nix files of the whole project. See
  [`implementation-guide.md` §16](implementation-guide.md#16-nix-fmt).

## 1. Repository structure

The repository follows the [dendritic
pattern](https://github.com/mightyiam/dendritic). In this pattern, every Nix
file under `modules/` is a flake-parts module. Most files add modules to
`flake.modules` for one or more configuration classes. Files in `modules/flake/`
and `modules/factories/` define flake outputs and options instead.

```text
.
├── docs/
│   ├── architecture.md
│   └── ...
├── lib/
│   └── default.nix
├── modules/
│   ├── factories/
│   ├── features/
│   ├── flake/
│   ├── homes/
│   ├── hosts/
│   ├── profiles/
│   └── users/
├── pkgs/
├── secrets/
├── stow/
├── flake.nix
└── ...
```

### Responsibilities

| Location             | Responsibility                                          |
| -------------------- | ------------------------------------------------------- |
| `lib/`               | Plain reusable Nix helper functions                     |
| `pkgs/`              | Custom package definitions                              |
| `secrets/`           | Encrypted credentials and data                          |
| `stow/`              | Dotfiles that GNU Stow links outside Nix                |
| `modules/flake/`     | Flake-parts infrastructure and concrete flake outputs   |
| `modules/features/`  | Reusable capabilities and integrations                  |
| `modules/factories/` | Factories that generate parameterized dendritic modules |
| `modules/profiles/`  | Reusable compositions of features and profiles          |
| `modules/hosts/`     | Concrete machine configurations                         |
| `modules/homes/`     | Concrete standalone Home Manager configurations         |
| `modules/users/`     | Concrete user definitions                               |

`modules/` contains Nix module code. `secrets/` stays at the repository root
because it holds encrypted data, not Nix code.

`flake.nix` imports the whole `modules/` tree with `import-tree`:

```nix
(import-tree ./modules)
```

To add a module to the flake-parts module tree, create its file under
`modules/`. `flake.nix` needs no separate import for each file. Because of this,
every `.nix` file under `modules/` must be a valid flake-parts module.
`import-tree` ignores files that don't end in `.nix`, so a feature can keep its
data files next to its module, for example `modules/features/vim/keymaps.vim`.
It also skips any path that contains `/_`, so a file or directory whose name
starts with `_` stays out of the flake-parts module tree. Plain helper code and
shared data still belong in `lib/`, `pkgs/`, or `secrets/`.

## 2. Configuration layers

### Features

A feature is one meaningful capability or integration, for example:

```text
git
ssh
docker
http
sops
neovim
homebrew
xdg
```

A feature can provide modules for several classes:

```nix
flake.modules.darwin.foo = ...;
flake.modules.homeManager.foo = ...;
```

A feature owns the packages, configuration, dependencies, and platform-specific
parts of its capability.

### Profiles

Profiles compose features and lower-level profiles into coherent environments,
for example:

```text
base
development
home-linux
home-linux-generic
home-darwin
```

A profile describes one coherent environment. It is not a bucket for unrelated
packages, because a bucket hides who owns each package and makes composition
unpredictable. A package that belongs to a capability goes in the feature for
that capability. Only development tools that don't justify a feature of their
own go directly in `development`.

### Hosts

A host is a machine, not a single user, and can contain several users. The name
of a host configuration must match the output of `scutil --get LocalHostName`.
`darwin-rebuild` uses that name to pick the configuration when you don't pass
one. Each host module sets `networking.hostName` to that name, and nix-darwin
sets `LocalHostName` to match during activation.

### Homes

A home is one user's standalone Home Manager environment on one host. Its name
has the form `user@host`, for example `dp@mbp-positive`. The host part must
match the output of `hostname`, `hostname -f`, or `hostname -s`. `home-manager`
uses `$USER@<hostname>` to pick the configuration when you don't pass one. A
home can add packages that only that home needs, such as tools for one employer,
even when they belong to a capability. The capability feature would install them
in every home that imports it.

Homes are standalone Home Manager configurations, not modules integrated into a
host configuration, for these reasons:

- One home model works on every platform, including Linux without NixOS, such as
  `dp@vm-ubuntu`.
- Activating a home doesn't need `sudo`.
- A change to user configuration activates only the home, not the whole system,
  so activation is quicker.
- System-level and user-level configuration stay separate.

### Users

A user module holds reusable user identity and configuration. A user definition
can provide a module for each class, for example:

```text
darwin.dp
homeManager.dp
```

Hosts and homes import the user module for their class.

## 3. Composition and dependencies

Dependencies point in this direction:

```text
profile  → feature
host     → profile/feature/user
home     → profile/feature/user
```

### Features don't import features

A feature module sets option values. It never imports another feature module.
Profiles, hosts, and homes compose shared dependencies once, never through the
`imports` of a feature. As a result, the module system merges each module value
only once per tree. The next section explains why that matters.

```nix
# Wrong: feature imports another feature (sops)
flake.modules.homeManager.foo = {
  imports = [ self.modules.homeManager.sops ];
  sops.secrets.my-secret = { ... };
};

# Right: sops composed once in base profile, feature just uses the options
flake.modules.homeManager.foo = {
  sops.secrets.my-secret = { ... };
};
```

### Profile hierarchy: avoid diamonds

The platform profiles `home-darwin` and `home-linux` import `base`. Feature
bundles, profiles such as `development` that only compose features, don't import
`base`. They expect the platform profile to put `base` in the tree.

If two import paths reach the same profile, they form a diamond.
`flake.modules.*` values are anonymous modules, not file paths. The module
system deduplicates only modules that it can key by file path, so it merges an
anonymous module once for each path that reaches it. Everything in a profile
that is reached twice loads twice. List values such as `home.packages` get
duplicate entries, and modules that declare options, such as `generic.meta`,
fail with an "option is already declared" error:

```text
Safe (tree)                         Unsafe (diamond)

      home config                         home config
       /       \                           /       \
home-darwin  development            home-darwin  development
     |                                      \     /
    base                                     base
                                        (merged twice)
```

In the unsafe shape, the module system merges `base` twice: once through
`home-darwin` and once through `development`.

A chain in which one profile specializes another is safe:

```text
home-linux-generic → home-linux → base
```

A concrete home imports exactly one platform profile: `home-darwin`,
`home-linux`, or `home-linux-generic`. A concrete host imports `base` directly,
because system classes are already platform-specific (§4). Either can add
feature bundles and individual features.

### Enable required tools with `lib.mkDefault`

If a feature needs a tool enabled, it sets `enable = lib.mkDefault true` for
that tool. For example, `python` needs `mise`, and `1password-ssh-agent` needs
`ssh`. The feature then works when it is used alone. When the feature of the
tool is also in the tree, its normal-priority `enable = true` takes precedence.
A profile can turn the tool off with `lib.mkForce false`.

```nix
# python.nix
flake.modules.homeManager.python = { lib, pkgs, ... }: {
  programs.mise = {
    enable = lib.mkDefault true;
    globalConfig.tools.python = "latest";
  };
};
```

### External option providers own their input module imports

Some features wrap external flake inputs to provide options that are not built
in. For example, `sops` wraps `sops-nix`, and `homebrew` wraps `nix-homebrew`.
Such a feature is the **provider**, and it imports the input modules that it
wraps:

```nix
# modules/features/sops.nix: the provider owns the imports
flake.modules.homeManager.sops = { ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    # ...every wrapped input module, imported here...
  ];
  # ...wiring for the provided options...
};
```

A feature that only **consumes** these options, such as `sops.secrets.*` or
`homebrew.*`, must not import the input modules. It must not import the
provider feature either, because that pulls in the input modules a second time
and creates a diamond. This is the "features don't import features" rule
applied transitively. The rule holds **per input module**: each input module
enters the tree exactly once, through its provider.

Several features can set the provided options, and their values merge as usual.
Only the import of the module that declares the options must be unique. If more
than one feature needs to import the same input module, move that import into a
dedicated provider feature, and make the other features consume it.

The module system can't always deduplicate an external module that is imported
twice. Some inputs, such as `nix-homebrew`, export module values instead of
paths, and the module system always merges those twice, as the diamond section
describes.

Compose the provider like any other feature: exactly once per tree, from the
profile that guarantees it, for example `base`. A consumer can appear only in a
tree that already contains the provider.

### Optional dependencies use `lib.mkIf` with a fallback

If a feature can use a dependency but doesn't need it, guard the dependent
configuration with `lib.mkIf` and provide a fallback. For example, `git` checks
`config.sops.secrets ? userEmail` and falls back to `config.meta.user.email`.
The guard makes the secret optional, not the `sops` feature: `git` still reads
`sops.*` options, so its tree must contain `sops`. The feature needs no import
and no assertion.

### Host modules need `_module.args.system`

`moduleWithSystem` needs to know the target system. If `_module.args.system` is
not set, it falls back to `config._module.args.pkgs`. The `nixpkgs` feature sets
that package set through `moduleWithSystem`, so the fallback causes infinite
recursion. Every host module must therefore set `_module.args.system`:

```nix
flake.modules.darwin.my-host = {
  nixpkgs.hostPlatform = "aarch64-darwin";
  _module.args = { system = "aarch64-darwin"; };
};
```

## 4. Configuration classes and platform scope

Class namespaces express scope:

```text
darwin
nixos
homeManager
generic
```

`darwin` and `nixos` modules are already platform-specific. `homeManager`
modules work on any OS, so platform-specific Home Manager compositions such as
`homeManager.home-darwin` are useful.

Don't create a redundant system profile such as `darwin.base-darwin` that only
re-exports `darwin.base`. It adds a second name for the same profile, and a tree
that imports both names reaches `base` twice (see §3).

Prefer a separate module for each platform over `isLinux` or `isDarwin`
conditionals. A module for one platform keeps unused configuration out of the
target module tree. Use a conditional only when one feature really spans
platforms, for example `1password-ssh-agent`, which picks the agent socket path
by platform.

## 5. Packages and nixpkgs

### `modules/features/packages.nix`

`packages.nix` is a feature for miscellaneous packages that don't justify a
feature of their own.

Create a feature for a single package only if the package has its own
configuration, dependencies, platform behavior, or purpose.

Group related packages into a capability feature, for example:

```text
http.nix   → httpie, hurl, posting
docker.nix → Docker-related tools/configuration
```

Development tools that don't justify a feature of their own can go directly in
`modules/profiles/development.nix`.

### `pkgs/`

Root `pkgs/` is the source of truth for custom package definitions.
`modules/flake/packages.nix` exposes every package in it through:

```text
self.packages.<system>.<name>
self.overlays.default
```

With the overlay applied, the local `pkgs` set contains the custom packages.

### Canonical `perSystem.pkgs`

`modules/flake/nixpkgs.nix` builds the configured `perSystem.pkgs` from the
pinned nixpkgs input, with `allowUnfree` and the custom overlay.

`perSystem` outputs and concrete configuration outputs reuse this package set.

Setting `perSystem.pkgs` doesn't change the package set of the module trees of
the separate configurations. Use `moduleWithSystem` in reusable modules that
need `perSystem` context. Use `withSystem` when you construct concrete flake
outputs that need `perSystem` values.

### `readOnlyPkgs`

`nixosModules.readOnlyPkgs` is a NixOS module. A NixOS configuration uses it to
consume the canonical package set, which is built outside the configuration,
without configuring that set again. nix-darwin and Home Manager have no
equivalent. nix-darwin takes the canonical package set through `nixpkgs.pkgs`,
and standalone Home Manager takes it through the `pkgs` argument of
`homeManagerConfiguration`.

## 6. Generic context and custom library

### `generic`

`flake.modules.generic.*` holds class-independent module options and context,
in typed, structured namespaces such as `meta.user.*`.

Configure native options such as `home.username` and `system.primaryUser`
directly. Generic context can supply their values, but it doesn't replace them.

### Custom library

Root `lib/` contains plain Nix helpers that don't depend on flake-parts or
configuration classes.

`lib/default.nix` is the top-level namespace for helper submodules.
`modules/flake/lib.nix` exposes it as:

```text
self.lib.my
```

`modules/features/my-lib.nix` defines `self.modules.generic.my-lib`, which
injects the library into a module tree as the `myLib` argument:

```nix
{ lib, myLib, ... }:
```

The standard `lib` argument stays unchanged. `lib` is the standard Nix and
module library, and `myLib` is the project library. Each module system already
passes its own `lib`. For example, Home Manager adds `lib.hm`. A separate
argument adds the project helpers without replacing or re-extending that `lib`
in every class.

`generic.my-lib` is class-independent. Import it from each base profile whose
tree uses the library, for example from both `darwin.base` and
`homeManager.base`.

Keep the plain library as independent of context as practical. If a helper
needs `self`, `pkgs`, or other context, pass that context as an argument.

## 7. Factories

A factory generates parameterized configuration. It is neither an ordinary
helper nor a ready-to-use module.

The three APIs have distinct roles:

```text
myLib.foo ...
    → calculate or transform a value

self.modules.homeManager.foo
    → ready-to-use module

self.factory.foo { ... }
    → generate configuration
```

Factories that generate class-specific `flake.modules` live in
`modules/factories/`, because they can need flake-parts context such as `self`,
module arguments, or `moduleWithSystem`.

`modules/flake/factory.nix` declares the flake-level factory registry. Each
factory stays in its own file under `modules/factories/`. The registry is a
flake-parts option for two reasons. Factories can need flake-parts context such
as `self`, and several factory modules can add to the shared `flake.factory.*`
namespace independently. In contrast, the values in `self.modules.*` are
ready-to-use modules.

A factory that generates modules for several classes returns an attrset with
the shape of `flake.modules`, for example:

```nix
{
  darwin.dp = ...;
  homeManager.dp = ...;
}
```

The result then merges directly into `flake.modules`, with no translation
layer.

## 8. Secrets and SOPS

`modules/features/sops.nix` provides the SOPS infrastructure.

Root `secrets/` is the central store for encrypted credentials:

```text
secrets/hosts/   → machine-specific credentials
secrets/homes/   → user-on-machine credentials
secrets/shared/  → credentials shared across configurations
```

Only `secrets/homes/` is in use today. `.sops.yaml` already has creation rules
for the other two scopes.

Use one encrypted file for each scope, domain, or service. Don't use one file
for the whole repository or one file for each secret. SOPS encrypts each file to
the recipients of its path rule in `.sops.yaml`. One file for the whole
repository would let every machine key decrypt every secret, and one file for
each secret adds files without better access control. YAML keys can be nested,
and `sops.secrets.<name>` doesn't depend on the YAML key path.

Encrypted application configuration that belongs to one feature can stay with
that feature, for example:

```text
modules/features/organize-tool/config.sops.yaml
```

Use this only for configuration that is part of the feature, not for general
credentials. Files outside `secrets/` match only the catch-all rule in
`.sops.yaml`, so only the master key can decrypt them.

A module that declares `sops.secrets.*` must be in a tree that contains the
`sops` feature.

Declare a secret such as a work Git email in the home that needs it, and let
the `git` feature consume it. The home then doesn't depend on how the `git`
feature works.

## 9. Naming and placement rules

- Name a feature file after its feature: `git.nix` defines
  `flake.modules.homeManager.git`. Use capability names such as `git`,
  `docker`, and `http`. A feature with data files uses a directory, such as
  `vim/default.nix`.
- A module name that starts with a digit, such as `1password`, can't appear as a
  bare name in a `with` import list, because Nix parses `[ 1password ]` as the
  two elements `1` and `password`. Reference it as
  `self.modules.darwin."1password"` instead.
- Name a factory file after its factory: `modules/factories/user.nix` defines
  `factory.user`.
- Keep flake infrastructure in `modules/flake/`: `configurations.nix`,
  `devshells.nix`, `factory.nix`, `formatter.nix`, `lib.nix`, `nixpkgs.nix`,
  and `packages.nix`.
- Keep generic reusable helpers in root `lib/`.
- Keep encrypted data in root `secrets/`.
- Name the Darwin-specific Home Manager composition `home-darwin`, not a
  redundant `base-darwin`.
