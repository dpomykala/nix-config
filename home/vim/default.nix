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
}
