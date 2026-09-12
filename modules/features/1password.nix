{ self, ... }: {
  flake.modules.darwin."1password" = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew = {
      casks = [ "password" ];

      # Applications from the Mac App Store (login required)
      # Applications installed in this way must be uninstalled manually
      # To search for an application ID: `mas search "1Password"`
      masApps."1Password for Safari" = 1569813296;
    };
  };
}
