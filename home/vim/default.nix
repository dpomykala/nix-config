{pkgs, ...}: {
  programs.vim = {
    enable = true;

    # Set Vim as the default editor using the EDITOR environment variable
    defaultEditor = true;

    plugins = [
      # Catppuccin color schemes for Vim and vim-airline
      pkgs.vimPlugins.catppuccin-vim
      pkgs.vimPlugins.vim-airline
    ];

    extraConfig = builtins.readFile ./vimrc;
  };
}
