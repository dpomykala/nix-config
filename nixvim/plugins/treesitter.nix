{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;

    nixvimInjections = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
      # TODO: Incremental selection?
    };

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      css
      csv
      dockerfile
      editorconfig
      gitignore
      html
      htmldjango
      javascript
      json
      just
      lua
      make
      markdown
      nginx
      nix
      python
      regex
      sql
      toml
      typescript
      vim
      xml
      yaml
    ];
  };

  /*
  Configure folding manually as the `plugins.treesitter.folding`
  option sets `foldexpr` to `nvim_treesitter#foldexpr()` which
  does not seem to work
  */
  opts = {
    # Use Treesitter based folding
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    # Use `foldexpr` for calculating fold levels
    foldmethod = "expr";
  };
}
