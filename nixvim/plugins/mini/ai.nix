{
  config,
  lib,
  ...
}: {
  plugins.mini.modules.ai = {
    custom_textobjects =
      {
        B.__raw = ''require("mini.extra").gen_ai_spec.buffer()'';
        D.__raw = ''require("mini.extra").gen_ai_spec.diagnostic()'';
        I.__raw = ''require("mini.extra").gen_ai_spec.indent()'';
        L.__raw = ''require("mini.extra").gen_ai_spec.line()'';
        N.__raw = ''require("mini.extra").gen_ai_spec.number()'';
      }
      # Custom Treesitter textobjects (nvim-treesitter-textobjects required)
      // lib.optionalAttrs config.plugins.treesitter-textobjects.enable {
        C.__raw = ''
          require("mini.ai").gen_spec.treesitter({
            a = "@conditional.outer", i = "@conditional.inner"
          })
        '';
        c.__raw = ''
          require("mini.ai").gen_spec.treesitter({
            a = "@class.outer", i = "@class.inner"
          })
        '';
        # NOTE: `l` is used as "last" by mini.ai (e.g. `vilb`)
        L.__raw = ''
          require("mini.ai").gen_spec.treesitter({
            a = "@loop.outer", i = "@loop.inner"
          })
        '';
        # Function (method) definition
        # This is consistent with the built-in keymaps `[m`, `]m`, etc.
        m.__raw = ''
          require("mini.ai").gen_spec.treesitter({
            a = "@function.outer", i = "@function.inner"
          })
        '';
        # Other block / scope
        o.__raw = ''
          require("mini.ai").gen_spec.treesitter({
            a = "@block.outer", i = "@block.inner"
          })
        '';
      };

    n_lines = 500;
  };
}
