{ self, ... }: {
  flake.modules.darwin.slack = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "slack" ];
  };
}
