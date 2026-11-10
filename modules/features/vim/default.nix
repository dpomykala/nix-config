_: {
  flake.modules.homeManager.vim =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.vim = {
        enable = true;
        # Terminal-only Vim, because the Home Manager default, vim-full, also
        # builds the GUI
        packageConfigurable = pkgs.vim;

        extraConfig = lib.concatStringsSep "\n" [
          (builtins.readFile ./options.vim)
          (builtins.readFile ./keymaps.vim)
        ];

        plugins = with pkgs; [
          # Catppuccin color schemes for Vim
          vimPlugins.catppuccin-vim
          # Status line
          vimPlugins.vim-airline
          # Indentation of Nix files
          vimPlugins.vim-nix
        ];
      };

      xdg = {
        # Vim doesn't create the swap and undo directories of options.vim
        stateFile."vim/swap/.keep".text = "";
        stateFile."vim/undo/.keep".text = "";

        configFile = {
          "vim/after/ftplugin/gitcommit.vim".text =
            # vim
            ''
              setlocal colorcolumn=51,73
              setlocal spell
              setlocal textwidth=72
            '';

          "vim/after/ftplugin/just.vim".text =
            # vim
            ''
              setlocal tabstop=4
            '';

          # The default ftplugin for make already sets `noexpandtab`
          "vim/after/ftplugin/make.vim".text =
            # vim
            ''
              setlocal tabstop=4
            '';
        };
      };
    };
}
