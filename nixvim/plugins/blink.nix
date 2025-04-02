_: {
  plugins.blink-cmp = {
    enable = true;

    settings = {
      completion = {
        documentation.auto_show = true;

        ghost_text.enabled = true;

        list.selection.auto_insert = false;

        # TODO: Use colorful-menu.nvim instead?
        menu.draw.treesitter = ["lsp"];
      };

      signature.enabled = true;
    };
  };
}
