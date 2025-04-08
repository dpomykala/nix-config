/*
nvim-treesitter-textobjects - syntax aware text-objects and more.

https://nix-community.github.io/nixvim/plugins/treesitter-textobjects
https://github.com/nvim-treesitter/nvim-treesitter-textobjects

NOTE: This plugin provides Treesitter captures that can be used e.g. for
creating custom textobjects with mini.ai (see: ../mini/ai.nix).
*/
_: {
  plugins.treesitter-textobjects = {
    enable = true;
  };
}
