/*
WezTerm configuration for generic Linux hosts.
*/
{
  config,
  lib,
  ...
}: {
  # Use a custom option to extend the common configuration
  # See: ../../common/wezterm.nix
  custom.wezterm.extraConfigExtended = lib.concatStringsSep "\n" (
    [
      # Lua
      ''
        config.font_size = 12.0
      ''
    ]
    ++ lib.optionals config.programs.zsh.enable [
      # Lua
      ''
        -- Configure WezTerm to run ZSH as a default program
        -- Home Manager by itself cannot change the default system/user shell
        config.default_prog = {"zsh", "-l"}
      ''
    ]
  );
}
