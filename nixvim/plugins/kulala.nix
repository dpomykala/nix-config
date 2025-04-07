/*
kulala.nvim - A fully-featured REST Client Interface for Neovim.

https://nix-community.github.io/nixvim/plugins/kulala/
https://github.com/mistweaverco/kulala.nvim

TODO: Use also kulala-fmt and kulala-ls?
*/
{pkgs, ...}: {
  plugins.kulala = {
    enable = true;

    settings = {
      global_keymaps = true;
    };
  };

  extraPackages = with pkgs; [
    curl
    jq
  ];
}
