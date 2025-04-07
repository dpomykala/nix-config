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
    ./statusline.nix
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
      cursorword = {};
      files = {};
      move = {};
      pairs = {};
      splitjoin = {};
      tabline = {};
    };
  };
}
