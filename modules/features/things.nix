{ self, ... }: {
  flake.modules.darwin.things = {
    imports = [ self.modules.darwin.homebrew ];

    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: `mas search "Things"`
    homebrew.masApps.Things = 904280696;
  };
}
