_: {
  flake.modules.homeManager.ghostty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      {
        programs.ghostty = {
          enable = true;

          settings = {
            # Nix pins the version, so the built-in updater must not run
            auto-update = "off";

            background-opacity = 0.8;
            # Implies `background-blur = true` for non-macOS platforms
            background-blur = "macos-glass-regular";

            confirm-close-surface = false;

            font-size = 16;

            keybind = [
              # Navigating between splits
              # Overrides the default `super+shift+j=write_screen_file:paste`
              "super+shift+h=goto_split:left"
              "super+shift+j=goto_split:down"
              "super+shift+k=goto_split:up"
              "super+shift+l=goto_split:right"
            ];

            maximize = true;

            mouse-hide-while-typing = true;

            theme = "Catppuccin Macchiato";

            unfocused-split-opacity = 0.7;

            window-padding-x = 10;
            window-padding-y = 10;
            window-padding-balance = true;
          };
        };
      }

      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        programs.ghostty = {
          # The default `ghostty` package builds only on Linux
          package = pkgs.ghostty-bin;

          settings = {
            keybind = [
              # Toggle the quick terminal, a drop-down terminal, from any app.
              # Only macOS gets it, because GNOME has no quick terminal and
              # would lose its Super+` window switcher to a binding that does
              # nothing. The binding replaces the macOS Cmd+` shortcut that
              # cycles the windows of an app, so use Cmd+Shift+` to cycle them
              # instead.
              "global:super+backquote=toggle_quick_terminal"
            ];

            # Use the left Option key as Alt for shell keybindings, such as the
            # OPTION-C keybinding of fzf
            macos-option-as-alt = "left";
          };
        };
      })

      (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && config.programs.zsh.enable) {
        # Run ZSH as the default program, because Home Manager by itself cannot
        # change the default system/user shell
        programs.ghostty.settings.command = "zsh -l";
      })
    ];
}
