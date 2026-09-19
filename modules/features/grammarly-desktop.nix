{ self, ... }: {
  flake.modules.darwin.grammarly-desktop = {
    homebrew.casks = [ "grammarly-desktop" ];
  };
}
