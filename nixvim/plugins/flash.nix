{lib, ...}: {
  plugins.flash = {
    enable = true;
  };

  keymaps = let
    inherit (lib.custom.nixvim) cCmdMap noxCmdMap oCmdMap oxCmdMap;
  in [
    (noxCmdMap {
      key = "s";
      cmd = "lua require('flash').jump()";
      desc = "Flash";
    })
    (noxCmdMap {
      key = "S";
      cmd = "lua require('flash').treesitter()";
      desc = "Flash Treesitter";
    })
    (oCmdMap {
      key = "r";
      cmd = "lua require('flash').remote()";
      desc = "Remote Flash";
    })
    (oxCmdMap {
      key = "R";
      cmd = "lua require('flash').treesitter_search()";
      desc = "Treesitter Search";
    })
    (cCmdMap {
      key = "<C-s>";
      cmd = "lua require('flash').toggle()";
      desc = "Toggle Flash Search";
    })
  ];
}
