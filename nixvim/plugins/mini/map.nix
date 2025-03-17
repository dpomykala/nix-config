{lib, ...}: {
  plugins.mini.modules.map = {
    integrations = [
      {__raw = "require('mini.map').gen_integration.builtin_search()";}
      {__raw = "require('mini.map').gen_integration.diagnostic()";}
      {__raw = "require('mini.map').gen_integration.diff()";}
    ];

    symbols = {
      encode = {__raw = "require('mini.map').gen_encode_symbols.dot('4x2')";};
    };
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>mf";
      cmd = "lua MiniMap.toggle_focus()";
      desc = "Focus";
    })
    (nCmdMap {
      key = "<Leader>mr";
      cmd = "lua MiniMap.refresh()";
      desc = "Refresh";
    })
    (nCmdMap {
      key = "<Leader>ms";
      cmd = "lua MiniMap.toggle_side()";
      desc = "Toggle side";
    })
    (nCmdMap {
      key = "<Leader>mt";
      cmd = "lua MiniMap.toggle()";
      desc = "Toggle";
    })
  ];
}
