# NOTE: Wezterm is installed via nix-darwin (Homebrew)
_: {
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
