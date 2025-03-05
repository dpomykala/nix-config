_: {
  imports = [
    ./basics.nix
    ./bufremove.nix
    ./clue.nix
    ./diff.nix
    ./files.nix
    ./hipatterns.nix
    ./icons.nix
    ./map.nix
    ./operators.nix
    # ./pick.nix
    ./surround.nix
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
      indentscope = {};
      move = {};
      notify = {};
      pairs = {};
      snippets = {};
      splitjoin = {};
      starter = {};
      statusline = {};
      tabline = {};
    };
  };
}
