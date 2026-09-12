{ self, ... }: {
  flake.modules.darwin.spotify = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "spotify" ];
  };
}
