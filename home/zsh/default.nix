{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./aliases.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    dotDir = ".config/zsh";

    autocd = true;
    history = {
      # Save the history file in the XDG Data Home directory
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      # Use the extended format for history entries
      extended = true;
    };

    # Local variables added at the top of .zshrc
    localVariables = {
      # Initialize zsh-vi-mode plugin when sourcing the script
      # This prevents overriding fzf key bindings (ctrl-r)
      # fzf must be sourced AFTER zsh-vi-mode
      # https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#initialization-mode
      ZVM_INIT_MODE = "sourcing";
      # Disable changing the cursor based on the mode (zsh-vi-mode)
      ZVM_CURSOR_STYLE_ENABLED = false;
    };

    # Extra configuration added to .zshrc
    initExtra = ''
      # Use Vim key bindings
      setopt VI
    '';

    # Plugins natively supported by home-manager
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Other plugins
    plugins = with pkgs; [
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
  };
}
