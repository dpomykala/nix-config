_: {
  flake.overlays.default =
    final: prev:
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
