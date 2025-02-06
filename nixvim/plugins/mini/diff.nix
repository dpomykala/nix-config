{...}: {
  plugins.mini.modules.diff = {
    view = {
      style = "sign";
      signs = {
        add = "┃";
        change = "┃";
        delete = "┃";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<Leader>go";
      action = "<Cmd>lua MiniDiff.toggle_overlay()<CR>";
      options = {desc = "Toggle diff overlay";};
    }
    {
      mode = "n";
      key = "<Leader>gs";
      action = "<Cmd>lua MiniGit.show_at_cursor()<CR>";
      options = {desc = "Show at cursor";};
    }
  ];
}
