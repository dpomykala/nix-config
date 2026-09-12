{ self, ... }: {
  flake.modules.darwin.obsidian = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "obsidian" ];
  };
}
