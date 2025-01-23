{ config, ... }: {
  home.file."${config.xdg.configHome}/wezterm/wezterm.lua".source = ./wezterm.lua;
}
