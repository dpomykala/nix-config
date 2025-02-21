{...}: {
  plugins.mini.modules.files = {
    windows = {preview = true;};
  };

  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>";
      options.desc = "Explore files (buffer)";
    }
    {
      mode = "n";
      key = "<Leader>ed";
      action = "<Cmd>lua MiniFiles.open()<CR>";
      options.desc = "Explore files (cwd)";
    }
  ];
}
