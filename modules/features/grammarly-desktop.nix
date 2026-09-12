{ self, ... }: {
  flake.modules.darwin.grammarly-desktop = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "grammarly-desktop" ];
  };
}
