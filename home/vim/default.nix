{
  lib,
  pkgs,
  ...
}: {
  programs.vim = {
    enable = true;

    plugins = with pkgs; [
      # Catppuccin color schemes for Vim
      vimPlugins.catppuccin-vim
      # The vim-airline plugin used for a status line
      vimPlugins.vim-airline
    ];

    extraConfig = lib.concatStringsSep "\n" [
      (builtins.readFile ./options.vim)
      (builtins.readFile ./keymaps.vim)
    ];
  };

  xdg = {
    # Create directories for Vim swap files and undo files
    stateFile."vim/swap/.keep".text = "";
    stateFile."vim/undo/.keep".text = "";

    # Custom ftplugins with configuration for specific file types
    configFile = {
      "vim/after/ftplugin/gitcommit.vim".text = ''
        setlocal colorcolumn=51,73
        setlocal spell
        setlocal textwidth=72
      '';

      "vim/after/ftplugin/just.vim".text = ''
        setlocal tabstop=4
      '';

      # NOTE: `noexpandtab` is already set in the default ftplugin for make
      "vim/after/ftplugin/make.vim".text = ''
        setlocal tabstop=4
      '';
    };
  };
}
