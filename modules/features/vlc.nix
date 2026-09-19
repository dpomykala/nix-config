{ self, ... }: {
  flake.modules.darwin.vlc = {
    homebrew.casks = [ "vlc" ];
  };
}
