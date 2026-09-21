# Nix Configuration Architecture

## TL;DR

- Use a **feature-oriented dendritic architecture** with `modules/features/`, `modules/profiles/`, `modules/hosts/`, `modules/homes/`, `modules/users/`, and `modules/factories/`.
- Features provide capabilities; profiles compose capabilities; hosts and homes are concrete entry points; users provide reusable user identity/configuration; factories generate parameterized configuration.
- Keep system and user environments separate: a host represents a machine and may have multiple users; a home represents one user's standalone Home Manager environment on one host.
- Use `flake.modules.<class>.<name>` for reusable modules and `flake.modules.generic.*` for class-independent module context.
- Keep flake infrastructure under `modules/flake/`; plain helper functions under root `lib/`; custom packages under root `pkgs/`; encrypted data under root `secrets/`.
- Use one canonical configured `perSystem.pkgs`; expose custom packages through both `self.packages.<system>` and `self.overlays.default`, and reuse the canonical package set for concrete configurations where appropriate.
- Use `moduleWithSystem` for reusable modules that need `perSystem` context and `withSystem` when constructing concrete flake outputs; use NixOS `readOnlyPkgs` when injecting the canonical package set into NixOS.
- Keep the standard module `lib` untouched. Expose project helpers as `self.lib.my` and inject them into module graphs as `myLib` through `self.modules.generic.my-lib`.
- Use `self.factory.*` for parameterized configuration generation. Dendritic factories that generate `flake.modules` live under `modules/factories/`; the option-backed factory registry lets independent factory modules contribute to a common namespace while retaining flake-parts context such as `self`.
- Keep SOPS credentials scope-based (`secrets/hosts`, `secrets/homes`, `secrets/shared`); feature-owned encrypted application configuration may remain next to the feature.
- Use `nixfmt-tree` for project-wide Nix formatting.
- Features don't import features. Shared dependencies are composed once in profiles, hosts, or homes. Use `lib.mkDefault true` for self-sufficient tool enablement.

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

Therefore, adding a Nix module under `modules/` is sufficient to make it part of the flake-parts module tree; `flake.nix` does not need a separate import for each file. File placement under `modules/` is consequently significant: files there are expected to be valid flake-parts modules, rather than arbitrary Nix helpers or data files.

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

Profiles compose features and lower-level profiles into coherent environments, e.g.:

```text
base
development
home-linux
home-linux-generic
home-darwin
```

Profiles should not become arbitrary package buckets.

### Hosts

A host represents a machine/system, not a single user. A host may contain multiple users.

### Homes

A home represents one user's standalone Home Manager environment on one host:

```text
user × host
```

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
never inside a feature's `imports`. This guarantees single-import per module
tree and avoids duplicate option declarations.

```nix
# Wrong: feature imports another feature
flake.modules.darwin.bear = {
  imports = [ self.modules.darwin.homebrew ];
  homebrew.masApps.Bear = 1091189122;
};

# Right: homebrew imported once in base profile, feature just uses options
flake.modules.darwin.bear = {
  homebrew.masApps.Bear = 1091189122;
};
```

### Profile hierarchy: avoid diamonds

Platform profiles (`home-darwin`, `home-linux`) import `base`. Feature bundles
(`development`) don't import `base` — they assume it's already in the tree
via the platform profile. Two imports converging on the same profile creates a
diamond, causing everything in that profile to load twice:

```text
Safe (tree)                          Unsafe (diamond)
 home config                          home config
          ↙                          /          \
home-darwin → base       home-darwin → base    development → base
development (features)       ↑_____________↑
                                   duplicate
```

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

### External option providers go in profiles

If a module wraps an external flake input (e.g., `sops-nix`, `nix-homebrew`)
to provide non-built-in options, import it once in a profile — not inside
individual features. That makes the options universally available without
duplication.

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

Use platform-specific module implementations instead of unnecessary `isLinux`/`isDarwin` conditionals. Use a conditional only when a single conceptual feature genuinely spans platforms.

## 5. Packages and Nixpkgs

### `modules/features/packages.nix`

`packages.nix` is a feature for miscellaneous packages that do not warrant their own capability feature.

Do not create one feature per package unless the package has independent configuration, dependencies, platform behavior, or conceptual identity.

Use capability features when appropriate, for example:

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

`nixosModules.readOnlyPkgs` is NixOS-specific and is used when NixOS should consume the canonical externally constructed `pkgs` without independently reconfiguring it. It is not a generic solution for nix-darwin or Home Manager.

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

A multi-class factory should return a `flake.modules`-shaped attrset, e.g.:

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
secrets/shared/  → credentials shared by selected configurations
```

Use one encrypted file per scope/domain/service rather than one repository-wide file or one file per individual secret. YAML keys may be nested, and `sops.secrets.<name>` is independent of the YAML key path.

Feature-owned encrypted application configuration may stay with the feature itself, e.g.:

```text
modules/features/organize-tool/config.sops.yaml
```

Use this for configuration that is intrinsically part of the feature, rather than general credentials.

A module that declares `sops.secrets.*` must have the SOPS Home Manager module available, directly or through an explicit composition dependency.

For secrets such as a work Git email, declare the secret in the relevant home and let the `git` feature consume it. This keeps the home independent of Git implementation details.

## 9. Naming and Placement Rules

- Name feature files after capabilities: `git.nix`, `docker.nix`, `http.nix`.
- Name feature files after the features they define: `git.nix` -> `flake.modules.homeManager.git`.
- Name factory files after factories: `modules/factories/user.nix` → `factory.user`.
- Keep flake infrastructure in `modules/flake/` (`packages.nix`, `nixpkgs.nix`, `lib.nix`, `factory.nix`, `configurations.nix`).
- Keep generic reusable helpers in root `lib/`.
- Keep encrypted data in root `secrets/`.
- Use `home-darwin` rather than a redundant `base-darwin` for Darwin-specific Home Manager composition.
