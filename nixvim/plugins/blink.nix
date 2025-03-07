_: {
  plugins.blink-cmp = {
    enable = true;

    settings = {
      appearance = {
        # TODO: Remove when the default value is changed to false
        use_nvim_cmp_as_default = false;
      };

      completion = {
        documentation.auto_show = true;

        ghost_text.enabled = true;

        list.selection.auto_insert = false;

        # menu.draw.treesitter = ["lsp"];
      };

      # TODO: Show documentation together with a signature?
      signature.enabled = true;
    };
  };
}
