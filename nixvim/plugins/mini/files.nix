{...}: {
  plugins.mini.modules.files = {};

  # Keymaps for the mini.files plugin
  keymaps = [
    {
      action = "<Cmd>lua MiniFiles.open()<CR>";
      key = "-";
      mode = "n";
    }
  ];
}
