_: {
  flake.modules.darwin.karabiner = {
    homebrew.casks = [ "karabiner-elements" ];
  };

  flake.modules.homeManager.karabiner = {
    # WARN: A change in the Karabiner GUI replaces the symlink with a file
    xdg.configFile."karabiner/karabiner.json" = {
      # Replace the file that the GUI wrote
      force = true;

      source = ./karabiner.json;
    };
  };
}
