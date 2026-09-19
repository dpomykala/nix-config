{ self, ... }: {
  flake.modules.darwin.brave-browser = {
    homebrew.casks = [ "brave-browser" ];
  };
}
