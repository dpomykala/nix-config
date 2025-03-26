{lib, ...}: {
  plugins.mini.modules.operators = {
    # The `gs` prefix conflicts with custom mappings for mini.surround
    sort.prefix = "g\\";
  };

  keymaps = let
    inherit (lib.custom.nixvim) nMap;
  in [
    # Remap the built-in `gx` mapping to `go` as `gx` is used by mini.operators
    (nMap {
      key = "go";
      action = "gx";
      desc = "";
    })
  ];
}
