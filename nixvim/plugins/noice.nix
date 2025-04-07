{
  config,
  lib,
  ...
}: {
  plugins.noice = {
    enable = true;

    settings = let
      inherit (lib) attrByPath;

      signatureViaBlink =
        config.plugins.blink-cmp.enable
        && (
          attrByPath
          ["signature" "enabled"]
          false
          config.plugins.blink-cmp.settings
        );
    in {
      lsp = {
        override = lib.nixvim.toRawKeys {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };

        # Disable if signature help is handled by blink.cmp
        signature.enabled = !signatureViaBlink;
      };

      presets = {
        long_message_to_split = true;

        # Add a border to hover docs and signature help
        lsp_doc_border = true;
      };
    };
  };

  keymaps = let
    inherit (lib.custom.nixvim) cMap nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>na";
      cmd = "Noice all";
      desc = "History (all)";
    })
    (nCmdMap {
      key = "<Leader>nD";
      cmd = "Noice disable";
      desc = "Disable";
    })
    (nCmdMap {
      key = "<Leader>nd";
      cmd = "Noice dismiss";
      desc = "Dismiss all";
    })
    (nCmdMap {
      key = "<Leader>nE";
      cmd = "Noice enable";
      desc = "Enable";
    })
    (nCmdMap {
      key = "<Leader>ne";
      cmd = "Noice errors";
      desc = "Errors";
    })
    (nCmdMap {
      key = "<Leader>nh";
      cmd = "Noice history";
      desc = "History";
    })
    (nCmdMap {
      key = "<Leader>nl";
      cmd = "Noice last";
      desc = "Last message";
    })
    (cMap {
      key = "<S-CR>";
      action = "lua require('noice').redirect(vim.fn.getcmdline())";
      desc = "Redirect cmdline";
    })
  ];
}
