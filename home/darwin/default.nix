/*
Configuration common to all Darwin hosts.
*/
{config, ...}: {
  imports = [
    ../common
    ./karabiner
    ./wezterm.nix
  ];

  home.homeDirectory = "/Users/${config.home.username}";
}
