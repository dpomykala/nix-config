{...}: {
  plugins.mini.modules.files = {};

  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>lua MiniFiles.open()<CR>";
      options = {desc = "Explore files";};
    }
  ];
}
