/*
WezTerm configuration for Darwin hosts.
*/
_: {
  # Use a custom option to extend the common configuration
  # See: home/common/wezterm.nix
  custom.wezterm.extraConfigExtended =
    # Lua
    ''
      config.font_size = 16.0
      config.window_decorations = 'RESIZE'
    '';
}
