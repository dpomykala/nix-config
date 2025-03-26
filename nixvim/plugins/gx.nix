{
  config,
  lib,
  ...
}: {
  plugins.gx = {
    enable = true;

    settings.handler_options.search_engine = "duckduckgo";
  };

  keymaps = let
    inherit (lib.custom.nixvim) hasMiniModule nxCmdMap;

    key =
      if (hasMiniModule config "operators")
      # Use `go` as `gx` is used by mini.operators
      then "go"
      else "gx";
  in [
    (nxCmdMap {
      key = "${key}";
      cmd = "Browse";
      desc = "Open in browser";
    })
  ];
}
