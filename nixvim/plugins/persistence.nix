{lib, ...}: {
  plugins.persistence.enable = true;

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    # Disable persistence - session won't be saved on exit
    (nCmdMap {
      key = "<Leader>sd";
      cmd = "lua require('persistence').stop()";
      desc = "Disable";
    })
    (nCmdMap {
      key = "<Leader>sl";
      cmd = "lua require('persistence').load({last = true})";
      desc = "Load last";
    })
    (nCmdMap {
      key = "<Leader>sr";
      cmd = "lua require('persistence').load()";
      desc = "Restore (cwd)";
    })
    (nCmdMap {
      key = "<Leader>ss";
      cmd = "lua require('persistence').select()";
      desc = "Select";
    })
  ];
}
