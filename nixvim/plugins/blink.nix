{
  config,
  lib,
  ...
}: {
  plugins = {
    blink-cmp = {
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

        sources = {
          default =
            [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ]
            ++ lib.optionals config.plugins.avante.enable [
              "avante_commands"
              "avante_mentions"
              "avante_files"
            ];

          providers = lib.mkIf config.plugins.avante.enable {
            avante_commands = {
              name = "avante_commands";
              module = "blink.compat.source";
              score_offset = 90;
              opts = {};
            };
            avante_files = {
              name = "avante_files";
              module = "blink.compat.source";
              score_offset = 100;
              opts = {};
            };
            avante_mentions = {
              name = "avante_mentions";
              module = "blink.compat.source";
              score_offset = 1000;
              opts = {};
            };
          };
        };
      };
    };

    blink-compat = lib.mkIf config.plugins.avante.enable {
      enable = true;

      luaConfig.post =
        # Lua
        ''
          -- HACK: Monkeypatch to avoid an error with Avante compat sources
          require("cmp").ConfirmBehavior = {
            Insert = "insert",
            Replace = "replace",
          }
        '';
    };
  };
}
