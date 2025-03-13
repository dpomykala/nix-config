{lib, ...}: {
  plugins.snacks.settings.scratch.enabled = true;

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>bS";
      cmd = "lua Snacks.scratch.select()";
      desc = "Scratch buffer (select)";
    })
    (nCmdMap {
      key = "<Leader>bs";
      cmd = "lua Snacks.scratch()";
      desc = "Scratch buffer";
    })
  ];
}
