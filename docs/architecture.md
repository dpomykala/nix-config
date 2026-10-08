# Nix Configuration Architecture

## Contents

- [TL;DR](#tldr)
- [1. Repository Structure](#1-repository-structure)
- [2. Configuration Layers](#2-configuration-layers)
- [3. Composition and Dependencies](#3-composition-and-dependencies)
- [4. Configuration Classes and Platform Scope](#4-configuration-classes-and-platform-scope)
- [5. Packages and Nixpkgs](#5-packages-and-nixpkgs)
- [6. Generic Context and Custom Library](#6-generic-context-and-custom-library)
- [7. Factories](#7-factories)
- [8. Secrets and SOPS](#8-secrets-and-sops)
- [9. Naming and Placement Rules](#9-naming-and-placement-rules)

## TL;DR

- Use a **feature-oriented dendritic architecture** with `modules/features/`, `modules/profiles/`, `modules/hosts/`, `modules/homes/`, `modules/users/`, and `modules/factories/`. — §1, §2
- Features provide capabilities; profiles compose capabilities; hosts and homes are concrete entry points; users provide reusable user identity/configuration; factories generate parameterized configuration. — §2
- Keep system and user environments separate: a host represents a machine and may have multiple users; a home represents one user's standalone Home Manager environment on one host. — §2
- Use `flake.modules.<class>.<name>` for reusable modules and `flake.modules.generic.*` for class-independent module context. — §4, §6
- Keep flake infrastructure under `modules/flake/`; plain helper functions under root `lib/`; custom packages under root `pkgs/`; encrypted data under root `secrets/`. — §1
- Use one canonical package set, configured as `perSystem.pkgs`; expose custom packages through both `self.packages.<system>` and `self.overlays.default`, and reuse the canonical package set for concrete configurations where appropriate. — §5
- Use `moduleWithSystem` for reusable modules that need `perSystem` context and `withSystem` when constructing concrete flake outputs; use NixOS `readOnlyPkgs` when injecting the canonical package set into NixOS. — §5
- Keep the standard module `lib` untouched. Expose project helpers as `self.lib.my` and inject them into module graphs as `myLib` through `self.modules.generic.my-lib`. — §6
- Use `self.factory.*` for parameterized configuration generation. Dendritic factories that generate `flake.modules` live under `modules/factories/`; the option-backed factory registry lets independent factory modules contribute to a common namespace while retaining flake-parts context such as `self`. — §7
- Keep SOPS credentials scope-based (`secrets/hosts`, `secrets/homes`, `secrets/shared`); feature-owned encrypted application configuration may remain next to the feature. — §8
- Use `nixfmt-tree` for project-wide Nix formatting. — see `implementation-guide.md` §16
- Features don't import features. Shared dependencies are composed once in profiles, hosts, or homes. Use `lib.mkDefault true` for self-sufficient tool enablement. — §3
- Import each external input module exactly once, in its provider feature; consumers only configure the options. — §3

## 1. Repository Structure

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

| Location             | Responsibility                                        |
| -------------------- | ----------------------------------------------------- |
| `lib/`               | Plain reusable Nix helpers/functions                  |
| `pkgs/`              | Custom package definitions                            |
| `secrets/`           | Encrypted credential/data files                       |
| `stow/`              | Dotfiles linked outside Nix (GNU Stow)                |
| `modules/flake/`     | Flake-parts infrastructure and concrete flake outputs |
| `modules/features/`  | Reusable capabilities/integrations                    |
| `modules/factories/` | Parameterized Dendritic configuration generators      |
| `modules/profiles/`  | Reusable compositions/specializations                 |
| `modules/hosts/`     | Concrete machine/system configurations                |
| `modules/homes/`     | Concrete standalone Home Manager configurations       |
| `modules/users/`     | Concrete user definitions/instances                   |

`modules/` contains Nix module code. `secrets/` is kept at repository root because it is encrypted data, not Nix code.

The entire `modules/` tree is automatically imported from `flake.nix` using `import-tree`:

```nix
(import-tree ./modules)
```

Therefore, adding a Nix module under `modules/` is sufficient to make it part of the flake-parts module tree; `flake.nix` does not need a separate import for each file. File placement under `modules/` is consequently significant: every `.nix` file there must be a valid flake-parts module. `import-tree` ignores non-nix files, so feature-owned data files may live next to the module that uses them (e.g. `modules/features/vim/keymaps.vim`); plain helper code and shared data still belong in `lib/`, `pkgs/`, or `secrets/`.

## 2. Configuration Layers

### Features

A feature represents one meaningful capability or integration, such as:

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

A feature may provide implementations for several classes:

```nix
flake.modules.darwin.foo = ...;
flake.modules.homeManager.foo = ...;
```

A feature owns the packages, configuration, dependencies, and platform-specific pieces that belong to that capability.

### Profiles

Profiles compose features and lower-level profiles into coherent environments, such as:

```text
base
development
home-linux
home-linux-generic
home-darwin
```

Profiles should not become arbitrary package buckets. A profile describes a coherent environment; a bucket erodes ownership and makes composition unpredictable. A package with a meaningful home belongs to its capability feature; only development-only packages without independent identity go directly in `development`.

### Hosts

A host represents a machine/system, not a single user. A host may contain multiple users. Configuration names must match the machine's `scutil --get LocalHostName` output.

### Homes

A home represents one user's standalone Home Manager environment on one host — the pair `user × host`, hence the `user@host` naming (e.g. `dp@mbp-positive`), where the host part must match the `hostname` output.

### Users

A user represents reusable identity/user configuration. User definitions may provide class-specific modules such as:

```text
darwin.dp
homeManager.dp
```

Hosts and homes select the appropriate class-specific user module.

## 3. Composition and Dependencies

The normal dependency direction is:

```text
profile  → feature
host     → profile/feature/user
home     → profile/feature/user
```

### Features don't import features

Feature modules set config values; they don't import other feature modules.
Shared dependencies are composed once at the profile, host, or home level,
never inside a feature's `imports`. This keeps every module value merged only
once per tree (see diamonds below for why that matters).

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

Platform profiles (`home-darwin`, `home-linux`) import `base`. Feature bundles
(`development`) don't import `base` — they assume it's already in the tree
via the platform profile. Two imports converging on the same profile create a
diamond. Unlike file paths, `flake.modules.*` values are anonymous modules: the
module system deduplicates only modules keyed by file path, so an anonymous
module reached twice is merged twice. Everything in that profile then loads
twice — list values (e.g. `home.packages`) get duplicated, and modules
declaring options (e.g. `generic.meta`) fail with an "option is already
declared" error:

```text
Safe (tree)                          Unsafe (diamond)
 home config                          home config
          ↙                          /          \
home-darwin → base       home-darwin → base    development → base
development (features)       ↑_____________↑
                                   duplicate
```

In the unsafe shape, `base` is merged twice: once through `home-darwin`, once through `development`.

A profile may specialize another profile through a chain, which is fine:

```text
home-linux-generic → home-linux → base
```

Concrete hosts/homes select exactly one platform profile plus optional feature
bundles and individual features.

### lib.mkDefault for tool enablement

When a feature needs a tool enabled (e.g., `python` needs `mise`, `1password-ssh-agent`
needs `ssh`), it sets `enable = lib.mkDefault true`. This makes the feature
self-sufficient when used alone, but the dedicated module's normal-priority
`enable = true` takes precedence when both are in the tree. A profile can
override with `lib.mkForce false`.

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

When a feature wraps one or more external flake inputs to provide non-built-in
options (`sops` wraps `sops-nix`; `homebrew` wraps `nix-homebrew`), that
feature is the **provider** and owns the imports of the wrapped input modules:

```nix
# modules/features/sops.nix — the provider owns the imports
flake.modules.homeManager.sops = { ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    # ...every wrapped input module, imported here...
  ];
  # ...wiring for the provided options...
};
```

Features that merely **consume** those options (`sops.secrets.*`,
`homebrew.*`) must not import the input modules directly — and must not
import the provider feature either, as that would pull the input modules in a
second time and recreate the diamond. This is the "features don't import
features" rule applied transitively. The invariant is **per input module**:
each one enters the tree exactly once, through the provider.

Several features may configure the provided options — values merge
normally; the uniqueness constraint applies only to the import of the
declaring module. If more than one feature would need to import the same
input module, extract a dedicated provider feature and consume it from the
others.

External modules cannot always be deduplicated when imported twice (see
diamonds above) — inputs may export module values rather than paths
(e.g. `nix-homebrew`), which are always merged twice.

The provider feature is composed like every feature: exactly once per tree,
from the profile that guarantees it (e.g. `base`). Consumers must only appear
in trees that already contain the provider, directly or through an explicit
composition dependency.

### Optional dependencies use lib.mkIf with fallback

If a feature can use a dependency but doesn't require it, guard with `lib.mkIf`
and provide a fallback. Example: `git` checks `config.sops.secrets ? userEmail`
and falls back to `config.meta.user.email`. No import, no assertion.

### Host modules need _module.args.system

For `moduleWithSystem` to determine the target system without falling through
to `config._module.args.pkgs` (which creates a cycle), host modules must set
`_module.args.system`:

```nix
flake.modules.darwin.my-host = {
  nixpkgs.hostPlatform = "aarch64-darwin";
  _module.args = { system = "aarch64-darwin"; };
};
```

## 4. Configuration Classes and Platform Scope

Use class namespaces to express scope:

```text
darwin
nixos
homeManager
generic
```

`darwin` and `nixos` are already system/platform-specific. `homeManager` is OS-independent, so platform-specific HM compositions such as `homeManager.home-darwin` are useful.

Do not create redundant system profiles such as `darwin.base-darwin` when the module only re-exports `darwin.base`.

Use platform-specific module implementations instead of unnecessary `isLinux`/`isDarwin` conditionals: a class-pure module keeps the target graph free of dead configuration and keeps evaluation honest. Use a conditional only when a single conceptual feature genuinely spans platforms (e.g. `1password-ssh-agent`, which selects the agent socket path by platform).

## 5. Packages and Nixpkgs

### `modules/features/packages.nix`

`packages.nix` is a feature for miscellaneous packages that do not warrant their own capability feature.

Do not create one feature per package unless the package has independent configuration, dependencies, platform behavior, or conceptual identity.

Use capability features when appropriate, such as:

```text
http.nix   → httpie, hurl, posting
docker.nix → Docker-related tools/configuration
```

Development-only packages that have no useful independent identity may be declared directly by `modules/profiles/development.nix`.

### `pkgs/`

Root `pkgs/` is the source of truth for custom package definitions. Its contents are automatically exposed through:

```text
self.packages.<system>.<name>
self.overlays.default
```

After applying the overlay, custom packages are available through the local `pkgs` set.

### Canonical `perSystem.pkgs`

`modules/flake/nixpkgs.nix` constructs the configured `perSystem.pkgs` using the pinned nixpkgs input, `allowUnfree`, and the custom overlay.

This package set should be reused by `perSystem` outputs and by concrete configuration outputs where appropriate.

Configuring `perSystem.pkgs` does not automatically configure the package set of those separate configuration graphs. Use `moduleWithSystem` for reusable modules that need `perSystem` context and `withSystem` when constructing concrete flake outputs that need `perSystem` values.

### `readOnlyPkgs`

`nixosModules.readOnlyPkgs` is NixOS-specific and is used when NixOS should consume the canonical package set (constructed externally) without independently reconfiguring it. It is not a generic solution for nix-darwin or Home Manager because no equivalent exists there: nix-darwin consumes the canonical set through `nixpkgs.pkgs`, and standalone Home Manager through the `pkgs` argument at construction.

## 6. Generic Context and Custom Library

### `generic`

Use `flake.modules.generic.*` for class-independent module options/context, with structured/typed namespaces such as `meta.user.*`.

Keep native options native (`home.username`, `system.primaryUser`, etc.); generic context may supply their values but does not replace them.

### Custom library

The root `lib/` contains plain Nix helpers independent of flake-parts and configuration classes.

`lib/default.nix` is the top-level namespace for helper submodules. It is exposed as:

```text
self.lib.my
```

by `modules/flake/lib.nix`.

`modules/features/my-lib.nix` defines:

```text
self.modules.generic.my-lib
```

which injects the library into a module graph as:

```nix
{ lib, myLib, ... }:
```

Keep the standard `lib` argument untouched; `lib` is the standard Nix/module library, while `myLib` is project-specific.

The `generic.my-lib` feature is class-agnostic and should normally be imported from the relevant base profile(s), e.g. both `darwin.base` and `homeManager.base` when both graphs use the library.

Keep the plain library as context-independent as practical. Pass `self`, `pkgs`, or other context explicitly to helpers that genuinely require it.

## 7. Factories

A factory is a parameterized configuration generator, not an ordinary helper and not a ready-to-use module.

The APIs have distinct roles:

```text
myLib.foo ...
    → calculate/transform a value

self.modules.homeManager.foo
    → ready-to-use module

self.factory.foo { ... }
    → generate configuration
```

Dendritic factories that generate class-specific `flake.modules` belong under `modules/factories/` because they may need flake-parts context (`self`, module arguments, `moduleWithSystem`, etc.).

`modules/flake/factory.nix` provides the flake-level factory registry; individual factories remain in separate files under `modules/factories/`. The registry is option-backed because factories may need flake-parts context such as `self`, and multiple factory modules can contribute independently to the common `flake.factory.*` namespace. This is different from `self.modules.*`, whose values are ready-to-use modules.

A multi-class factory should return a `flake.modules`-shaped attrset, such as:

```nix
{
  darwin.dp = ...;
  homeManager.dp = ...;
}
```

so the result can be merged directly into `flake.modules` without a manual translation layer.

## 8. Secrets and SOPS

SOPS infrastructure is provided by `modules/features/sops.nix`.

Root `secrets/` is the centralized store for encrypted credentials:

```text
secrets/hosts/   → machine-specific credentials
secrets/homes/   → user-on-machine credentials
secrets/shared/  → credentials shared across configurations
```

Use one encrypted file per scope/domain/service rather than one repository-wide file or one file per individual secret. YAML keys may be nested, and `sops.secrets.<name>` is independent of the YAML key path.

Feature-owned encrypted application configuration may stay with the feature itself, such as:

```text
modules/features/organize-tool/config.sops.yaml
```

Use this for configuration that is intrinsically part of the feature, rather than general credentials.

A module that declares `sops.secrets.*` must have the SOPS Home Manager module available, directly or through an explicit composition dependency.

For secrets such as a work Git email, declare the secret in the relevant home and let the `git` feature consume it. This keeps the home independent of Git implementation details.

## 9. Naming and Placement Rules

- Name feature files after the feature they define: `git.nix` → `flake.modules.homeManager.git` (capability names like `git`, `docker`, `http`).
- Name factory files after factories: `modules/factories/user.nix` → `factory.user`.
- Keep flake infrastructure in `modules/flake/` (`configurations.nix`, `devshells.nix`, `factory.nix`, `formatter.nix`, `lib.nix`, `nixpkgs.nix`, `packages.nix`).
- Keep generic reusable helpers in root `lib/`.
- Keep encrypted data in root `secrets/`.
- Use `home-darwin` rather than a redundant `base-darwin` for Darwin-specific Home Manager composition.
