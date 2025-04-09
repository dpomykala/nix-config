/*
blink.cmp - performant, batteries-included completion plugin.

https://nix-community.github.io/nixvim/plugins/blink-cmp
https://github.com/Saghen/blink.cmp
*/
{
  config,
  lib,
  pkgs,
  ...
}: {
  plugins.blink-cmp = {
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
          lib.optional config.plugins.avante.enable "avante"
          ++ [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];

        per_filetype = {
          # Provided by codecompanion.nvim
          codecompanion = ["codecompanion"];
        };

        providers = {
          avante = lib.mkIf config.plugins.avante.enable {
            module = "blink-cmp-avante";
            name = "Avante";
            opts = {
              kind_icons.Avante = " ";
            };
          };
        };
      };
    };
  };

  extraPlugins = lib.optionals config.plugins.avante.enable [
    # https://github.com/Kaiser-Yang/blink-cmp-avante
    pkgs.vimPlugins.blink-cmp-avante
  ];
}
