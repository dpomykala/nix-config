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
            confirm-close-surface = false;

            theme = "Catppuccin Macchiato";
          };
        };
      }

      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        programs.ghostty = {
          # The default `ghostty` package builds only on Linux
          package = pkgs.ghostty-bin;

          settings = {
            # Nix pins the version, so the built-in updater must not run
            auto-update = "off";

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
