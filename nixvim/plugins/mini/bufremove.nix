_: {
  plugins.mini.modules.bufremove = {};

  keymaps = [
    {
      mode = "n";
      key = "<Leader>bb";
      action = "<Cmd>b#<CR>";
      options.desc = "Previously visited buffer";
    }
    {
      mode = "n";
      key = "<Leader>bd";
      action = "<Cmd>lua MiniBufremove.delete()<CR>";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<Leader>bD";
      action = "<Cmd>lua MiniBufremove.delete(0, true)<CR>";
      options.desc = "Delete! buffer";
    }
  ];
}
