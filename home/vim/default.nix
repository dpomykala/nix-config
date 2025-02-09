{pkgs, ...}: {
  programs.vim = {
    enable = true;

    plugins = [
      # Catppuccin color schemes for Vim
      pkgs.vimPlugins.catppuccin-vim
      # The vim-airline plugin used for a status line
      pkgs.vimPlugins.vim-airline
    ];

    extraConfig = builtins.readFile ./vimrc;
  };
}
