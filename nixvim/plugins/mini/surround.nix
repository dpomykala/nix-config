_: {
  plugins.mini.modules.surround = {
    # Use the `gs` prefix to reserve the `s` key for flash.nvim
    mappings = {
      add = "gsa";
      delete = "gsd";
      find = "gsf";
      find_left = "gsF";
      highlight = "gsh";
      replace = "gsr";
      update_n_lines = "gsn";
    };
  };
}
