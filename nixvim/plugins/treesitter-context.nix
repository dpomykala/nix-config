/*
nvim-treesitter-context - shows the context of the visible content.

https://nix-community.github.io/nixvim/plugins/treesitter-context
https://github.com/nvim-treesitter/nvim-treesitter-context
*/
_: {
  plugins.treesitter-context = {
    enable = true;

    settings = {
      max_lines = 3;
    };
  };
}
