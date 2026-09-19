{ self, ... }: {
  flake.modules.darwin.pages = {
    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: `mas search "Pages"`
    homebrew.masApps.Pages = 361309726;
  };
}
