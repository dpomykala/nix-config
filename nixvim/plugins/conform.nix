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

      format_on_save.__raw = ''
        function(bufnr)
          -- Disable formatting on save with a global or buffer-local variable
          if vim.g.autoformat_disable or vim.b[bufnr].autoformat_disable then
            return
          end
          return {timeout_ms = 500} -- Default: 1000
        end
      '';

      # NOTE: LSP formatting is used for some languages (e.g. Python)
      formatters_by_ft =
        {
          just = ["just"];
          lua = ["stylua"];
          nix = ["alejandra"];
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
      key = "\\F";
      cmd = "AutoformatToggle";
      desc = "Toggle formatting";
    })
    (nCmdMap {
      key = "\\f";
      cmd = "AutoformatBufferToggle";
      desc = "Toggle formatting (buffer)";
    })
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

  userCommands = {
    AutoformatToggle = {
      command.__raw = ''
        function()
          vim.g.autoformat_disable = not vim.g.autoformat_disable
          local status = not vim.g.autoformat_disable and "enabled" or "disabled"
          print("Formatting on save is globally " .. status)
        end
      '';
      desc = "Toggle automatic formatting on save (globally)";
    };

    AutoformatBufferToggle = {
      command.__raw = ''
        function()
          vim.b.autoformat_disable = not vim.b.autoformat_disable
          local status = not vim.b.autoformat_disable and "enabled" or "disabled"
          print("Formatting on save is locally " .. status)
        end
      '';
      desc = "Toggle automatic formatting on save for the current buffer";
    };
  };
}
