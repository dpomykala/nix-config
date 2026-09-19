{ self, ... }: {
  flake.modules.darwin."nvidia-geforce-now" = {
    homebrew.casks = [ "nvidia-geforce-now" ];
  };
}
