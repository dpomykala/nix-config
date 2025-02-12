# NOTE: Karabiner-Elements is installed via nix-darwin (Homebrew)
{config, ...}: {
  # NOTE: Any configuration changes via the GUI will overwrite the symlink
  home.file."${config.xdg.configHome}/karabiner/karabiner.json".source =
    ./karabiner.json;
}
