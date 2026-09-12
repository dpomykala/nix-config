{ self, ... }: {
  flake.modules.darwin."nvidia-geforce-now" = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "nvidia-geforce-now" ];
  };
}
