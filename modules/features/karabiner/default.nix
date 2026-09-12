{ self, ... }: {
  flake.modules.darwin.karabiner = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "karabiner-elements" ];
  };

  flake.modules.homeManager.karabiner = {
    # WARN: Any configuration changes via the GUI will overwrite the symlink
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
