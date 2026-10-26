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
        # Use terminal-only vim. The Home Manager default, vim-full, builds
        # a GUI version that is not used here.
        packageConfigurable = pkgs.vim;

        extraConfig = lib.concatStringsSep "\n" [
          (builtins.readFile ./options.vim)
          (builtins.readFile ./keymaps.vim)
        ];

        plugins = with pkgs; [
          # Catppuccin color schemes for Vim
          vimPlugins.catppuccin-vim
          # The vim-airline plugin used for a status line
          vimPlugins.vim-airline
          # The vim-nix plugin used for Nix file indentation
          vimPlugins.vim-nix
        ];
      };

      xdg = {
        # Create directories for Vim swap files and undo files
        stateFile."vim/swap/.keep".text = "";
        stateFile."vim/undo/.keep".text = "";

        # Custom ftplugins with configuration for specific file types
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

          # NOTE: `noexpandtab` is already set in the default ftplugin for make
          "vim/after/ftplugin/make.vim".text =
            # vim
            ''
              setlocal tabstop=4
            '';
        };
      };
    };
}
