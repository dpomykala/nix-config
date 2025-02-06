{...}: {
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

  keymaps = [
    {
      mode = "n";
      key = "<Leader>mf";
      action = "<Cmd>lua MiniMap.toggle_focus()<CR>";
      options = {desc = "Focus map";};
    }
    {
      mode = "n";
      key = "<Leader>mr";
      action = "<Cmd>lua MiniMap.refresh()<CR>";
      options = {desc = "Refresh map";};
    }
    {
      mode = "n";
      key = "<Leader>ms";
      action = "<Cmd>lua MiniMap.toggle_side()<CR>";
      options = {desc = "Toggle map side";};
    }
    {
      mode = "n";
      key = "<Leader>mt";
      action = "<Cmd>lua MiniMap.toggle()<CR>";
      options = {desc = "Toggle map";};
    }
  ];
}
