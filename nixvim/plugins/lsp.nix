{
  config,
  lib,
  ...
}: let
  snacksPickerEnabled =
    config.plugins.snacks.enable
    && config.plugins.snacks.settings ? picker
    && config.plugins.snacks.settings.picker.enabled;

  inherit (lib.custom.nixvim) mkNormCmdMap;
in {
  plugins.lsp = {
    enable = true;

    inlayHints = true;

    keymaps = {
      # diagnostic = {};

      extra = lib.optionals snacksPickerEnabled [
        (mkNormCmdMap {
          key = "gD";
          cmd = "lua Snacks.picker.lsp_declarations()";
        })
        (mkNormCmdMap {
          key = "gd";
          cmd = "lua Snacks.picker.lsp_definitions()";
        })
        (mkNormCmdMap {
          key = "gli";
          cmd = "lua Snacks.picker.lsp_implementations()";
        })
        (mkNormCmdMap {
          key = "glr";
          cmd = "lua Snacks.picker.lsp_references()";
        })
        (mkNormCmdMap {
          key = "glS";
          cmd = "lua Snacks.picker.lsp_workspace_symbols()";
        })
        (mkNormCmdMap {
          key = "gls";
          cmd = "lua Snacks.picker.lsp_symbols()";
        })
        (mkNormCmdMap {
          key = "glt";
          cmd = "lua Snacks.picker.lsp_type_definitions()";
        })
      ];

      lspBuf =
        {
          gK = "signature_help";

          "<Leader>la" = "code_action";
          "<Leader>lr" = "rename";
        }
        // lib.optionalAttrs (!snacksPickerEnabled) {
          gD = "declaration";
          gd = "definition";
          gli = "implementation";
          glr = "references";
          glS = "workspace_symbol";
          gls = "document_symbol";
          glt = "type_definition";
        };

      silent = true;
    };

    servers = {
      html.enable = true;
      lua_ls.enable = true;
      pyright.enable = true;
    };
  };
}
