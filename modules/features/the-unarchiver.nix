{ self, ... }: {
  flake.modules.darwin.the-unarchiver = {
    homebrew.casks = [ "the-unarchiver" ];
  };
}
