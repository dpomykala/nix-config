{ self, ... }: {
  flake.modules.darwin.numbers = {
    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: `mas search "Numbers"`
    homebrew.masApps.Numbers = 361304891;
  };
}
