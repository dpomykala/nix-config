/*
grug-far.nvim - Grug find! Grug replace! Grug happy!

https://nix-community.github.io/nixvim/plugins/grug-far
https://github.com/MagicDuck/grug-far.nvim
*/
{
  lib,
  pkgs,
  ...
}: {
  plugins.grug-far = {
    enable = true;
  };

  extraPackages = with pkgs; [
    ast-grep
    ripgrep
  ];

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap nMap nxCmdMap xCmdMap;
  in [
    # Uses ast-grep: https://github.com/ast-grep/ast-grep
    (nxCmdMap {
      key = "<Leader>ra";
      cmd = "lua require('grug-far').open({engine = 'astgrep'})";
      desc = "Using ast-grep";
    })
    (nxCmdMap {
      key = "<Leader>rb";
      cmd = "lua require('grug-far').open({prefills = {paths = vim.fn.expand('%')}})";
      desc = "Inside buffer";
    })
    (nxCmdMap {
      key = "<Leader>rg";
      cmd = "lua require('grug-far').open()";
      desc = "Using ripgrep";
    })
    (xCmdMap {
      key = "<Leader>rv";
      cmd = "lua require('grug-far').open({visualSelectionUsage = 'operate-within-range'})";
      desc = "Inside range";
    })
    (nCmdMap {
      key = "<Leader>rW";
      cmd = "lua require('grug-far').open({prefills = {search = vim.fn.expand('<cword>')}})";
      desc = "Word (global)";
    })
    (nMap {
      key = "<Leader>rw";
      action.__raw = ''
        function()
          require('grug-far').open(
            {
              prefills = {
                paths = vim.fn.expand('%'),
                search = vim.fn.expand('<cword>'),
              }
            }
          )
        end
      '';
      desc = "Word (buffer)";
    })
  ];
}
