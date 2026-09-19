{ self, ... }: {
  flake.modules.darwin.spotify = {
    homebrew.casks = [ "spotify" ];
  };
}
