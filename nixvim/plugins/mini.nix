{...}: {
  plugins.mini = {
    enable = true;

    # Use mini.icons to emulate nvim-web-devicons
    mockDevIcons = true;

    modules = {
      ai = {};

      animate = {};

      align = {};

      basics = {
        mappings.windows = true;
      };

      bracketed = {};

      bufremove = {};

      clue = {};

      # TODO: Can it be replaced with the built-in functionality?
      comment = {};

      cursorword = {};

      diff = {
        view.style = "sign";
      };

      extra = {};

      files = {};

      git = {};

      hipatterns = {};

      icons = {};

      indentscope = {};

      jump = {};

      jump2d = {};

      map = {};

      move = {};

      notify = {};

      operators = {};

      pairs = {};

      pick = {};

      snippets = {};

      splitjoin = {};

      starter = {};

      statusline = {};

      surround = {};

      tabline = {};
    };
  };
}
