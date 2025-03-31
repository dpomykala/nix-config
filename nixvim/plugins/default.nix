_: {
  imports = [
    ./blink.nix
    ./conform.nix
    ./flash.nix
    ./gitsigns.nix
    ./grug-far.nix
    ./gx.nix
    ./lint.nix
    ./lsp.nix
    ./mini
    ./noice.nix
    ./persistence.nix
    ./snacks
    ./todo-comments.nix
    ./treesitter-context.nix
    ./treesitter.nix
  ];

  plugins = {
    friendly-snippets.enable = true;
    neoconf.enable = true;
  };
}
