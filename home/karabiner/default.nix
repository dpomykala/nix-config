# NOTE: Karabiner-Elements is installed via nix-darwin (Homebrew)
_: {
  # NOTE: Any configuration changes via the GUI will overwrite the symlink
  xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
}
