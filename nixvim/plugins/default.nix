_: {
  imports = [
    ./blink.nix
    ./conform.nix
    ./flash.nix
    ./lint.nix
    ./lsp.nix
    ./mini
    ./noice.nix
    ./snacks
    ./treesitter.nix
  ];

  plugins.friendly-snippets.enable = true;
}
