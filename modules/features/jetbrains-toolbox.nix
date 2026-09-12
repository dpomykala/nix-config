{ self, ... }: {
  flake.modules.darwin.jetbrains-toolbox = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "jetbrains-toolbox" ];
  };
}
