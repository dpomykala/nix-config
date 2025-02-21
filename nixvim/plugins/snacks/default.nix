{...}: {
  plugins.snacks = {
    enable = true;

    settings = {
      input = {
        enabled = true;
      };
      # NOTE: Used by noice.nvim
      notifier = {
        enabled = true;
      };
      picker = {
        enabled = true;
      };
    };
  };
}
