_: {
  flake.module.homeManager.wezterm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      {
        programs.wezterm = {
          enable = true;

          # NOTE: The nixGL wrapper is used only if `nixGL.packages` are specified
          package = config.lib.nixGL.wrap pkgs.wezterm;

          extraConfig =
            # Lua
            ''
              -- Maximize the terminal window on startup
              wezterm.on("gui-startup", function(cmd)
                  local _, _, window = wezterm.mux.spawn_window(cmd or {})
                  window:gui_window():maximize()
              end)
            '';

          settings = {
            color_scheme = "Catppuccin Macchiato";

            font =
              lib.generators.mkLuaInline
                # Lua
                ''wezterm.font "FiraCode Nerd Font"'';

            window_background_opacity = 0.9;
            window_close_confirmation = "NeverPrompt";
            window_frame.font =
              lib.generators.mkLuaInline
                # Lua
                ''wezterm.font { family = "Noto Sans", weight = "Regular" }'';

            hide_tab_bar_if_only_one_tab = true;

            keys = [
              {
                key = "|";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.SplitHorizontal{domain =  "CurrentPaneDomain"}'';
              }
              {
                key = "Enter";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.SplitVertical{domain =  "CurrentPaneDomain"}'';
              }
              {
                key = "h";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.ActivatePaneDirection("Left")'';
              }
              {
                key = "j";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.ActivatePaneDirection("Down")'';
              }
              {
                key = "k";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.ActivatePaneDirection("Up")'';
              }
              {
                key = "l";
                mods = "SUPER|SHIFT";
                action =
                  lib.generators.mkLuaInline
                    # Lua
                    ''act.ActivatePaneDirection("Right")'';
              }
            ];
          };
        };
      }

      (lib.mkIf pkgs.stdenv.isDarwin {
        programs.wezterm.settings = {
          font_size = 16;
          window_decorations = "RESIZE";
        };
      })

      (lib.mkIf pkgs.stdenv.isLinux {
        programs.wezterm.settings = {
          font_size = 12;
        }
        // lib.optionalAttrs config.programs.zsh.enable {
          # Configure WezTerm to run ZSH as a default program
          # Home Manager by itself cannot change the default system/user shell
          default_prog = [
            "zsh"
            "-l"
          ];
        };
      })
    ];
}
