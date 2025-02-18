{pkgs, ...}: {
  programs.vim = {
    enable = true;

    plugins = with pkgs; [
      # Catppuccin color schemes for Vim
      vimPlugins.catppuccin-vim
      # The vim-airline plugin used for a status line
      vimPlugins.vim-airline
    ];

    extraConfig = builtins.readFile ./vimrc;
  };

  # Create directories for Vim swap files and undo files
  xdg.stateFile."vim/swap/.keep".text = "";
  xdg.stateFile."vim/undo/.keep".text = "";

  # NOTE: `noexpandtab` is already set in the default ftplugin for make
  xdg.configFile."vim/after/ftplugin/make.vim".text = ''
    set tabstop=4
  '';

  xdg.configFile."vim/after/ftplugin/just.vim".text = ''
    set tabstop=4
  '';
}
