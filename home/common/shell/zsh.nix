{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autocd = true;

    autosuggestion.enable = true;

    dotDir = "${config.xdg.configHome}/zsh";

    initContent = let
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
      # Configure fzf-tab completion BEFORE compinit
      lib.mkIf config.programs.fzf.enable (lib.mkOrder 550 ''
        # Disable sorting when completing some git commands
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':completion:*:git-reset:*' sort false

        # Use FZF_DEFAULT_OPTS for fzf-tab
        zstyle ':fzf-tab:*' use-fzf-default-opts yes

        # Preview directory's content when completing `cd`
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${dirPreview}'
      '');

    history = {
      # Use the extended format for history entries
      extended = true;

      # Save the history file in the XDG Data Home directory
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    # Local variables added at the top of .zshrc
    localVariables = {
      # Disable changing the cursor based on the mode (zsh-vi-mode)
      # ZVM_CURSOR_STYLE_ENABLED = false;

      # Initialize zsh-vi-mode plugin when sourcing the script
      # This prevents overriding fzf key bindings (ctrl-r)
      # fzf must be sourced AFTER zsh-vi-mode
      # https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#initialization-mode
      ZVM_INIT_MODE = "sourcing";
    };

    plugins = with pkgs; [
      # https://github.com/Aloxaf/fzf-tab
      # Requires fzf to be installed
      (
        lib.mkIf config.programs.fzf.enable {
          inherit (zsh-fzf-tab) src;
          name = "fzf-tab";
        }
      )
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
}
