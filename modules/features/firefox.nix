{ self, ... }: {
  flake.modules.darwin.firefox = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "firefox" ];
  };
}
