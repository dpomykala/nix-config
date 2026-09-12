{ self, ... }: {
  flake.modules.darwin.logi-options-plus = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "logi-options+" ];
  };
}
