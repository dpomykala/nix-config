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
      extra =
        [
          # Language servers mappings
          (mkNormCmdMap {
            key = "<Leader>ll";
            cmd = "LspLog";
            desc = "LS logs";
          })
          (mkNormCmdMap {
            key = "<Leader>lr";
            cmd = "Lsprestart";
            desc = "LS restart";
          })
          (mkNormCmdMap {
            key = "<Leader>lS";
            cmd = "LspStop";
            desc = "LS stop";
          })
        ]
        ++ lib.optionals snacksPickerEnabled [
          (mkNormCmdMap {
            key = "gD";
            cmd = "lua Snacks.picker.lsp_declarations()";
            desc = "Goto declaration (LSP)";
          })
          (mkNormCmdMap {
            key = "gd";
            cmd = "lua Snacks.picker.lsp_definitions()";
            desc = "Goto definition (LSP)";
          })
          (mkNormCmdMap {
            key = "gli";
            cmd = "lua Snacks.picker.lsp_implementations()";
            desc = "Goto implementation";
          })
          (mkNormCmdMap {
            key = "glr";
            cmd = "lua Snacks.picker.lsp_references()";
            desc = "References";
          })
          (mkNormCmdMap {
            key = "glS";
            cmd = "lua Snacks.picker.lsp_workspace_symbols()";
            desc = "Symbols (workspace)";
          })
          (mkNormCmdMap {
            key = "gls";
            cmd = "lua Snacks.picker.lsp_symbols()";
            desc = "Symbols (buffer)";
          })
          (mkNormCmdMap {
            key = "glt";
            cmd = "lua Snacks.picker.lsp_type_definitions()";
            desc = "Goto type definition";
          })
        ];

      lspBuf =
        {
          # Use signature mappings consistent with `K` for the `hover` action
          gK = {
            action = "signature_help";
            desc = "Signature help (LSP)";
          };
          "<C-k>" = {
            mode = "i";
            action = "signature_help";
            desc = "Signature help (LSP)";
          };

          gla = {
            action = "code_action";
            desc = "Actions";
          };
          glR = {
            action = "rename";
            desc = "Rename";
          };
        }
        // lib.optionalAttrs (!snacksPickerEnabled) {
          gD = {
            action = "declaration";
            desc = "Goto declaration (LSP)";
          };
          gd = {
            action = "definition";
            desc = "Goto definition (LSP)";
          };
          gli = {
            action = "implementation";
            desc = "Goto implementation";
          };
          glr = {
            action = "references";
            desc = "References";
          };
          glS = {
            action = "workspace_symbol";
            desc = "Symbols (workspace)";
          };
          gls = {
            action = "document_symbol";
            desc = "Symbols (buffer)";
          };
          glt = {
            action = "type_definition";
            desc = "Goto type definition";
          };
        };

      silent = true;
    };

    servers = {
      html.enable = true;
      lua_ls.enable = true;
      pyright.enable = true;
    };
  };

  # Global mappings (available also if there is no LS attached)
  keymaps = [
    # Language servers mappings
    (mkNormCmdMap {
      key = "<Leader>li";
      cmd = "check lspconfig";
      desc = "LS info";
    })
    (mkNormCmdMap {
      key = "<Leader>ls";
      cmd = "LspStart";
      desc = "LS start";
    })
  ];
}
