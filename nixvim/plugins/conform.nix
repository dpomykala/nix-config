{
  lib,
  pkgs,
  ...
}: let
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
          -- Disable automatic formatting with a global or buffer-local variable
          if vim.g.autoformat_disable or vim.b[bufnr].autoformat_disable then
            return
          end
          -- FIXME: Increase timeout (e.g. for prettier 500 ms is not enough)?
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

  extraPackages = with pkgs; [
    alejandra
    just
    nodePackages.prettier
    shellcheck
    shfmt
    stylua
  ];

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
          print("Auto-formatting (global): " .. status)
        end
      '';
      desc = "Toggle automatic formatting (globally)";
    };

    AutoformatBufferToggle = {
      command.__raw = ''
        function()
          vim.b.autoformat_disable = not vim.b.autoformat_disable
          local status = not vim.b.autoformat_disable and "enabled" or "disabled"
          print("Auto-formatting (buffer): " .. status)
        end
      '';
      desc = "Toggle automatic formatting for the current buffer";
    };
  };
}
