/*
gx.nvim - better implementation of the built-in gx.

https://nix-community.github.io/nixvim/plugins/gx
https://github.com/chrishrb/gx.nvim
*/
{lib, ...}: {
  plugins.gx = {
    enable = true;

    settings.handler_options.search_engine = "duckduckgo";
  };

  keymaps = let
    inherit (lib.custom.nixvim) nxCmdMap;
  in [
    # Use `go` as `gx` might be used by mini.operators
    (nxCmdMap {
      key = "go";
      cmd = "Browse";
      desc = "Open in browser";
    })
  ];
}
