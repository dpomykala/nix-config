{...}: {
  plugins.mini.modules.map = {};

  keymaps = [
    {
      mode = "n";
      key = "<leader>mt";
      action = "<cmd>lua MiniMap.toggle()<CR>";
      options = {desc = "Toggle map";};
    }
  ];
}
