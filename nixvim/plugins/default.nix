_: {
  imports = [
    ./ai
    ./blink.nix
    ./conform.nix
    ./flash.nix
    ./gitsigns.nix
    ./grug-far.nix
    ./gx.nix
    ./kulala.nix
    ./lint.nix
    ./lsp.nix
    ./mini
    ./noice.nix
    ./persistence.nix
    ./snacks
    ./todo-comments.nix
    ./treesitter
  ];

  plugins = {
    friendly-snippets.enable = true;
    neoconf.enable = true;
  };
}
