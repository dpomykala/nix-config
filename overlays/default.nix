_: {
  # Custom apps
  apps = final: prev: (
    prev.lib.packagesFromDirectoryRecursive {
      directory = ../apps;
    }
  );
}
