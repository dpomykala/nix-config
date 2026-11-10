# Linux-only feature
_: {
  flake.modules.homeManager.dconf = {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        # Remap Caps Lock to Escape
        xkb-options = [ "caps:escape" ];
      };
    };
  };
}
