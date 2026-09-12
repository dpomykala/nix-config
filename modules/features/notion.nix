{ self, ... }: {
  flake.modules.darwin.notion = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "notion" ];
  };
}
