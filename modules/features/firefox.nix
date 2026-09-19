{ self, ... }: {
  flake.modules.darwin.firefox = {
    homebrew.casks = [ "firefox" ];
  };
}
