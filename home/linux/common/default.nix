/*
Configuration common to all Linux-based hosts (NixOS, non-NixOS, WSL).
*/
{config, ...}: {
  imports = [
    ../../common
  ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Remap Capslock to Escape
      xkb-options = ["caps:escape"];
    };
  };

  home.homeDirectory = "/home/${config.home.username}";
}
