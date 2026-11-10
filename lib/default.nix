/*
  Custom Nix helpers for this configuration.

  This file is the top-level namespace of the library. It exposes the helper
  submodules that other files in this directory define, each under its own
  name, for example:

    {
      secrets = import ./secrets.nix;
      packages = import ./packages.nix;
    }

  The library contains plain Nix functions that don't depend on flake-parts or
  on a configuration class. It reaches the modules through three layers:

  - `lib/default.nix` exposes all helper submodules.
  - `modules/flake/lib.nix` exposes the library as the `flake.lib.my` output.
  - `modules/features/my-lib.nix` defines the `self.modules.generic.my-lib`
    feature, which passes the library to modules as the `myLib` argument.

  The `generic.my-lib` feature works in every class. Each module of a Darwin,
  Home Manager, or NixOS module tree that imports it gets the same `myLib`.

  Usage:

    { lib, myLib, ... }: {
      someOption = myLib.secrets.someHelper ...;
    }

  `myLib` exists only in a module tree that imports
  `self.modules.generic.my-lib`. The base profile imports it.
*/
{ }
