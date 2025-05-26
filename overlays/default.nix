_: {
  # Custom apps
  apps = final: prev:
    prev.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ../apps;
    };
}
