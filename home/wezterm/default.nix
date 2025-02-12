# NOTE: Wezterm is installed via nix-darwin (Homebrew)
{config, ...}: {
  home.file."${config.xdg.configHome}/wezterm/wezterm.lua".source =
    ./wezterm.lua;
}
