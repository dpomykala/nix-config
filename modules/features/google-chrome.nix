{ self, ... }: {
  flake.modules.darwin.google-chrome = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "google-chrome" ];
  };
}
