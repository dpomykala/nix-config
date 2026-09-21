/*
  Custom, reusable Nix helpers for this configuration.

  This file is the top-level namespace for the library, exposing specific helper
  submodules defined in separate files under this directory. To expose a helper
  submodule, import it under the desired namespace, e.g.:

    {
      secrets = import ./secrets.nix;
      packages = import ./packages.nix;
    }

  The library contains plain Nix functions, independent of flake-parts and
  configuration classes. It is exposed as the `self.lib.my` flake output and
  injected into module graphs as the `myLib` module argument.

  Layers:

  - `lib/default.nix` - exposes all helper submodules.
  - `modules/flake/lib.nix` - exposes the library as the `flake.lib.my` output.
  - `modules/features/my-lib.nix` - defines the `self.modules.generic.my-lib`
    feature that provides the `myLib` argument to the module system.

  The `generic.my-lib` feature is configuration-class agnostic: when imported
  into a Darwin, Home Manager, or NixOS module graph, it makes the same `myLib`
  library available to that graph's modules.

  Usage:

    { lib, myLib, ... }: {
      someOption = myLib.secrets.someHelper ...;
    }

  The `self.modules.generic.my-lib` feature must be imported somewhere in the
  module graph (e.g. in the base profile) before `myLib` is available as a
  module argument.
*/
{ }
