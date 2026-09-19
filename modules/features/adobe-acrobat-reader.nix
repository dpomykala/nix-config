{ self, ... }: {
  flake.modules.darwin.adobe-acrobat-reader = {
    homebrew.casks = [ "adobe-acrobat-reader" ];
  };
}
