_: {
  flake.modules.darwin.shell = {
    programs.zsh = {
      # Skip compinit in /etc/zshrc, because Home Manager runs it in .zshrc
      enableCompletion = false;

      enableBashCompletion = false;
    };
  };

  flake.modules.homeManager.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # The aliases of a tool go in the feature of that tool
      home.shellAliases = {
        cl = "clear";
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;

        autocd = true;

        autosuggestion.enable = true;

        dotDir = "${config.xdg.configHome}/zsh";

        initContent =
          let
            dirPreview = lib.concatStringsSep " " [
              "eza"
              "--color=always"
              "--icons"
              "--hyperlink"
              "--group-directories-first"
              "--tree"
              "--level 3"
              "$realpath"
            ];
          in
          # fzf-tab needs these styles before compinit runs
          lib.mkIf config.programs.fzf.enable (
            lib.mkOrder 550 ''
              # Disable sorting when completing some git commands
              zstyle ':completion:*:git-checkout:*' sort false
              zstyle ':completion:*:git-reset:*' sort false

              # Use FZF_DEFAULT_OPTS for fzf-tab
              zstyle ':fzf-tab:*' use-fzf-default-opts yes

              # Preview the directory when completing `cd`
              zstyle ':fzf-tab:complete:cd:*' fzf-preview '${dirPreview}'
            ''
          );

        history = {
          # Save the start time and duration of each command
          extended = true;

          path = "${config.xdg.dataHome}/zsh/zsh_history";
        };

        # Local variables added at the top of .zshrc
        localVariables = {
          # Disable changing the cursor based on the mode (zsh-vi-mode)
          # ZVM_CURSOR_STYLE_ENABLED = false;

          /*
            Initialize zsh-vi-mode when its script is sourced, so that it
            doesn't override the fzf key bindings, such as Ctrl-R. fzf must
            load after zsh-vi-mode. See
            https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#initialization-mode
          */
          ZVM_INIT_MODE = "sourcing";
        };

        plugins = with pkgs; [
          # https://github.com/Aloxaf/fzf-tab
          # Requires fzf to be installed
          (lib.mkIf config.programs.fzf.enable {
            inherit (zsh-fzf-tab) src;
            name = "fzf-tab";
          })
          # https://github.com/jeffreytse/zsh-vi-mode
          {
            inherit (zsh-vi-mode) src;
            name = "zsh-vi-mode";
          }
          # https://github.com/MichaelAquilina/zsh-you-should-use
          {
            inherit (zsh-you-should-use) src;
            name = "zsh-you-should-use";
          }
        ];

        setOptions = [
          # Use Vim key bindings
          "VI"
        ];

        syntaxHighlighting.enable = true;
      };
    };
}
