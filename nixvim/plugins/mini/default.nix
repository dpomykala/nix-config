_: {
  imports = [
    ./animate.nix
    ./basics.nix
    ./clue.nix
    ./files.nix
    ./hipatterns.nix
    ./icons.nix
    ./indentscope.nix
    ./map.nix
    ./operators.nix
    # ./sessions.nix
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
      files = {};
      move = {};
      pairs = {};
      splitjoin = {};
      statusline = {};
      tabline = {};
    };
  };
}
