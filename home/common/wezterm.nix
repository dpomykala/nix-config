{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.wezterm = {
    # Use a custom option to allow other modules to extend the common config
    extraConfigExtended = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extended WezTerm configuration.";
    };
  };

  config.programs.wezterm = let
    extendedConfigList =
      lib.optional
      (config.custom.wezterm.extraConfigExtended != "")
      config.custom.wezterm.extraConfigExtended;
  in {
    enable = true;

    # NOTE: The nixGL wrapper is used only if `nixGL.packages` are specified
    package = config.lib.nixGL.wrap pkgs.wezterm;

    extraConfig = lib.concatStringsSep "\n" (
      # NOTE: The `wezterm` Lua module is defined by Home Manager
      [
        # Lua
        ''
          local act = wezterm.action
          local mux = wezterm.mux
          local config =  wezterm.config_builder()

          -- Maximize the terminal window on startup
          wezterm.on("gui-startup", function(cmd)
              local _, _, window = mux.spawn_window(cmd or {})
              window:gui_window():maximize()
          end)

          config.color_scheme = "Catppuccin Macchiato"

          config.font = wezterm.font "FiraCode Nerd Font"

          --config.window_background_opacity = 0.9
          config.window_close_confirmation = "NeverPrompt"
          config.window_frame = {
              font = wezterm.font { family = "Noto Sans", weight = "Regular" },
          }

          config.hide_tab_bar_if_only_one_tab = true

          config.keys = {
            {
              key = "|",
              mods = "SUPER|SHIFT",
              action = act.SplitHorizontal{domain =  "CurrentPaneDomain"},
            },
            {
              key = "Enter",
              mods = "SUPER|SHIFT",
              action = act.SplitVertical{domain =  "CurrentPaneDomain"},
            },
            {
              key = "h",
              mods = "SUPER|SHIFT",
              action = act.ActivatePaneDirection("Left"),
            },
            {
              key = "j",
              mods = "SUPER|SHIFT",
              action = act.ActivatePaneDirection("Down"),
            },
            {
              key = "k",
              mods = "SUPER|SHIFT",
              action = act.ActivatePaneDirection("Up"),
            },
            {
              key = "l",
              mods = "SUPER|SHIFT",
              action = act.ActivatePaneDirection("Right"),
            },
          }
        ''
      ]
      ++ extendedConfigList
      ++ ["return config"]
    );
  };
}
