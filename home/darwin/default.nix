/*
Configuration common to all Darwin hosts.
*/
{config, ...}: {
  imports = [
    ../common
    ./karabiner
    ./preferences.nix
    ./wezterm.nix
  ];

  home.homeDirectory = "/Users/${config.home.username}";
}
