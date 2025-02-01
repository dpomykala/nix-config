{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;

    folding = true;
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
      xml
      yaml
    ];
  };
}
