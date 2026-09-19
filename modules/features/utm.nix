{ self, ... }: {
  flake.modules.darwin.utm = {
    homebrew.casks = [ "utm" ];
  };
}
