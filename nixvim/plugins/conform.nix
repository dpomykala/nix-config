{lib, ...}: let
  inherit (lib) genAttrs;
  inherit (lib.custom.nixvim) nCmdMap nxCmdMap;
in {
  plugins.conform-nvim = {
    enable = true;

    settings = {
      default_format_opts = {
        # Try using LSP formatting if no other formatters ara available
        lsp_format = "fallback";
      };

      format_on_save = {
        timeout_ms = 500; # Default: 1000
      };

      formatters_by_ft =
        {
          just = ["just"];
          lua = ["stylua"];
          nix = ["alejandra"];
          python = ["ruff_organize_imports" "ruff_format"];
        }
        # File types formatted using prettier
        // genAttrs [
          "css"
          "html"
          "javascript"
          "javascriptreact"
          "json"
          "markdown"
          "typescript"
          "typescriptreact"
          "yaml"
        ] (_: ["prettier"])
        # File types formatted using shellcheck and sh (shfmt)
        // genAttrs ["bash" "sh"] (_: ["shellcheck" "shfmt"]);
    };
  };

  keymaps = [
    (nCmdMap {
      key = "<Leader>cF";
      cmd = "ConformInfo";
      desc = "Formatters info";
    })
    (nxCmdMap {
      key = "<Leader>cf";
      cmd = "lua require('conform').format()";
      desc = "Format file/range";
    })
  ];

  opts = {
    # Use conform.nvim for built-in formatting operations (e.g. with `gq`)
    formatexpr = "v:lua.require'conform'.formatexpr()";
  };
}
