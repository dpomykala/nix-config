{ self, ... }: {
  flake.modules.darwin.slack = {
    homebrew.casks = [ "slack" ];
  };
}
