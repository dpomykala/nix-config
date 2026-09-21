# Linux-only feature.
_: {
  flake.modules.homeManager.dconf = {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        # Remap Capslock to Escape
        xkb-options = [ "caps:escape" ];
      };
    };
  };
}
