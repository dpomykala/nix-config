{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.custom.nixvim) hasSnacksModule nCmdMap;

  hasSnacksPicker = hasSnacksModule config "picker";
in {
  plugins.lsp = {
    enable = true;

    inlayHints = true;

    keymaps = {
      extra =
        [
          # Language servers mappings
          (nCmdMap {
            key = "<Leader>ll";
            cmd = "LspLog";
            desc = "LS logs";
          })
          (nCmdMap {
            key = "<Leader>lr";
            cmd = "Lsprestart";
            desc = "LS restart";
          })
          (nCmdMap {
            key = "<Leader>lS";
            cmd = "LspStop";
            desc = "LS stop";
          })
        ]
        ++ lib.optionals hasSnacksPicker [
          (nCmdMap {
            key = "gD";
            cmd = "lua Snacks.picker.lsp_declarations()";
            desc = "Goto declaration (LSP)";
          })
          (nCmdMap {
            key = "gd";
            cmd = "lua Snacks.picker.lsp_definitions()";
            desc = "Goto definition (LSP)";
          })
          (nCmdMap {
            key = "gli";
            cmd = "lua Snacks.picker.lsp_implementations()";
            desc = "Goto implementation";
          })
          (nCmdMap {
            key = "glr";
            cmd = "lua Snacks.picker.lsp_references()";
            desc = "References";
          })
          (nCmdMap {
            key = "glS";
            cmd = "lua Snacks.picker.lsp_workspace_symbols()";
            desc = "Symbols (workspace)";
          })
          (nCmdMap {
            key = "gls";
            cmd = "lua Snacks.picker.lsp_symbols()";
            desc = "Symbols (buffer)";
          })
          (nCmdMap {
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
          glf = {
            mode = ["n" "x"];
            action = "format";
            desc = "Format file/range (LSP)";
          };
          glR = {
            action = "rename";
            desc = "Rename";
          };
        }
        // lib.optionalAttrs (!hasSnacksPicker) {
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

      nixd = {
        enable = true;

        settings = let
          flake =
            # nix
            ''(builtins.getFlake "${self}")'';
        in {
          formatting.command = ["alejandra"];
          nixpkgs.expr =
            # nix
            "import ${flake}.inputs.nixpkgs {}";
          options = {
            home-manager.expr =
              # nix
              ''
                let configs = ${flake}.homeConfigurations;
                in (builtins.head (builtins.attrValues configs)).options
              '';
            nix-darwin.expr =
              # nix
              ''
                let configs = ${flake}.darwinConfigurations;
                in (builtins.head (builtins.attrValues configs)).options
              '';
            nixvim.expr =
              # nix
              "${flake}.packages.${pkgs.system}.nvim.options";
          };
        };
      };

      pyright = {
        enable = true;

        settings = {
          pyright = {
            # Disable Pyright's import organizer in favor of Ruff
            disableOrganizeImports = true;
          };
        };
      };

      ruff = {
        enable = true;

        # Disable Ruff's hover in favor of Pyright
        onAttach.function =
          # lua
          ''
            client.server_capabilities.hoverProvider = false
          '';
      };

      typos_lsp = {
        enable = true;

        # Render typos as warnings
        extraOptions.init_options.diagnosticSeverity = "Warning";

        # Disable typos LSP in help pages
        onAttach.function =
          # lua
          ''
            -- Use schedule to make sure that a file type is already set
            vim.schedule(function()
              if vim.bo[bufnr].filetype == "help" then
                vim.lsp.buf_detach_client(bufnr, client.id)
                return
              end
            end)
          '';
      };
    };
  };

  # Global mappings (available also if there is no LS attached)
  keymaps = [
    # Language servers mappings
    (nCmdMap {
      key = "<Leader>li";
      cmd = "check lspconfig";
      desc = "LS info";
    })
    (nCmdMap {
      key = "<Leader>ls";
      cmd = "LspStart";
      desc = "LS start";
    })
  ];
}
