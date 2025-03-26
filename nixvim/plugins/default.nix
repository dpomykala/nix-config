_: {
  imports = [
    ./blink.nix
    ./conform.nix
    ./flash.nix
    ./gitsigns.nix
    ./gx.nix
    ./lint.nix
    ./lsp.nix
    ./mini
    ./noice.nix
    ./persistence.nix
    ./snacks
    ./todo-comments.nix
    ./treesitter.nix
  ];

  plugins = {
    friendly-snippets.enable = true;
    neoconf.enable = true;
  };
}
