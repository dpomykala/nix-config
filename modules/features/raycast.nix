{ self, ... }: {
  flake.modules.darwin.raycast = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "raycast" ];
  };
}
