{ self, ... }: {
  flake.modules.darwin.vlc = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "vlc" ];
  };
}
