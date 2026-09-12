{ self, ... }: {
  flake.modules.darwin.bear = {
    imports = [ self.modules.darwin.homebrew ];

    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: `mas search "Bear"`
    homebrew.masApps.Bear = 1091189122;
  };
}
