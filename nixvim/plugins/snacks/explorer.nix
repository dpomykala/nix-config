{lib, ...}: {
  plugins.snacks.settings.explorer = {
    enabled = true;

    replace_netrw = false;
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>et";
      cmd = "lua Snacks.explorer.open()";
      desc = "Snacks explorer (tree)";
    })
  ];
}
