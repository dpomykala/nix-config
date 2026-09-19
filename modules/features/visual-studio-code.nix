{ self, ... }: {
  flake.modules.darwin.visual-studio-code = {
    homebrew.casks = [ "visual-studio-code" ];
  };
}
