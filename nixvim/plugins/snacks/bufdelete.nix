{lib, ...}: {
  plugins.snacks.settings.bufdelete.enabled = true;

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>ba";
      cmd = "lua Snacks.bufdelete.all()";
      desc = "Delete all buffers";
    })
    (nCmdMap {
      key = "<Leader>bb";
      cmd = "b#";
      desc = "Recent buffer";
    })
    (nCmdMap {
      key = "<Leader>bD";
      cmd = "lua Snacks.bufdelete.delete({force = true})";
      desc = "Delete buffer (force)";
    })
    (nCmdMap {
      key = "<Leader>bd";
      cmd = "lua Snacks.bufdelete.delete()";
      desc = "Delete buffer";
    })
    (nCmdMap {
      key = "<Leader>bo";
      cmd = "lua Snacks.bufdelete.other()";
      desc = "Delete other buffers";
    })
  ];
}
