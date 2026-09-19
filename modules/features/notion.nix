{ self, ... }: {
  flake.modules.darwin.notion = {
    homebrew.casks = [ "notion" ];
  };
}
