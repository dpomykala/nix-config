{...}: {
  imports = [
    ./basics.nix
    ./clue.nix
    ./diff.nix
    ./files.nix
    ./map.nix
    ./pick.nix
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
      bufremove = {};
      # TODO: Can it be replaced with the built-in functionality?
      comment = {};
      cursorword = {};
      extra = {};
      files = {};
      git = {};
      hipatterns = {};
      icons = {};
      indentscope = {};
      jump = {};
      jump2d = {};
      move = {};
      notify = {};
      operators = {};
      pairs = {};
      snippets = {};
      splitjoin = {};
      starter = {};
      statusline = {};
      surround = {};
      tabline = {};
    };
  };
}
