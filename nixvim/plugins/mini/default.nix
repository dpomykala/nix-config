_: {
  imports = [
    ./animate.nix
    ./basics.nix
    ./bufremove.nix
    ./clue.nix
    ./diff.nix
    ./files.nix
    ./hipatterns.nix
    ./icons.nix
    ./indentscope.nix
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
      align = {};
      bracketed = {};
      # TODO: Can it be replaced with the built-in functionality?
      comment = {};
      cursorword = {};
      extra = {};
      files = {};
      git = {};
      move = {};
      pairs = {};
      splitjoin = {};
      starter = {};
      statusline = {};
      tabline = {};
    };
  };
}
