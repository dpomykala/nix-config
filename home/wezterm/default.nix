# NOTE: Wezterm is installed via nix-darwin (Homebrew)
{...}: {
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
