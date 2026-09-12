{ self, ... }: {
  flake.modules.darwin.the-unarchiver = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "the-unarchiver" ];
  };
}
