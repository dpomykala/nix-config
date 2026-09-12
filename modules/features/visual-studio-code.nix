{ self, ... }: {
  flake.modules.darwin.visual-studio-code = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "visual-studio-code" ];
  };
}
