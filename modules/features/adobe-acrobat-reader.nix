{ self, ... }: {
  flake.modules.darwin.adobe-acrobat-reader = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "adobe-acrobat-reader" ];
  };
}
