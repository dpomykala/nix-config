{ self, ... }: {
  flake.modules.darwin.obsidian = {
    homebrew.casks = [ "obsidian" ];
  };
}
