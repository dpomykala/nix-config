{ self, ... }: {
  flake.modules.darwin.brave-browser = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "brave-browser" ];
  };
}
