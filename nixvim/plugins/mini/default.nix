{...}: {
  imports = [
    ./basics.nix
    ./bufremove.nix
    ./clue.nix
    ./diff.nix
    ./files.nix
    ./hipatterns.nix
    ./map.nix
    # ./pick.nix
  ];

  plugins.mini = {
    enable = true;

    # Use mini.icons to emulate nvim-web-devicons
    mockDevIcons = true;

    modules = {
      ai = {};
      animate = {};
      align = {};
      bracketed = {};
      # TODO: Can it be replaced with the built-in functionality?
      comment = {};
      cursorword = {};
      extra = {};
      files = {};
      git = {};
      icons = {};
      indentscope = {};
      move = {};
      notify = {};
      operators = {
        # The `gs` prefix conflicts with custom mappings for mini.surround
        sort.prefix = "g\\";
      };
      pairs = {};
      snippets = {};
      splitjoin = {};
      starter = {};
      statusline = {};
      surround = {
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
      tabline = {};
    };
  };
}
