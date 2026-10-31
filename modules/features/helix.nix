/*
  Helix editor and its language wiring, written for Helix 25.07.1.

  Language features install the language servers and formatters. This module
  only tells Helix which of them to use for each language. Helix skips a server
  or a formatter that isn't on PATH.

  Each language entry lists only the servers of that language. `addServers`
  adds the servers that many languages share, because Helix can't yet enable a
  server for all languages. See
  https://github.com/helix-editor/helix/issues/12721.
*/
_: {
  flake.modules.homeManager.helix =
    { lib, ... }:
    {
      programs.helix =
        let
          addServers =
            names:
            {
              first ? [ ],
              last ? [ ],
            }:
            # Without this check, a misspelled name would add nothing silently
            assert lib.assertMsg (lib.all (
              name: lib.elem name languageNames
            ) names) "addServers: a language in [ ${toString names} ] has no entry";
            map (
              lang:
              if lib.elem lang.name names then
                lang // { language-servers = first ++ lang.language-servers ++ last; }
              else
                lang
            );

          # An entry with `names` sets the same config for each of the languages
          expandNames = lib.concatMap (
            lang: map (name: removeAttrs lang [ "names" ] // { inherit name; }) (lang.names or [ lang.name ])
          );

          # A `language-servers` list replaces the whole default list, so each
          # list repeats the defaults that it keeps. Helix already auto-formats
          # Go, Rust, and Zig.
          languages = expandNames [
            {
              name = "bash";
              auto-format = true;
              language-servers = [ "bash-language-server" ];
            }
            {
              names = [
                "css"
                "scss"
              ];
              auto-format = true;
              language-servers = [ "vscode-css-language-server" ];
            }
            {
              name = "docker-compose";
              auto-format = true;
              # Helix master default, remove after the next release (> 25.07.1)
              language-id = "dockercompose";
              language-servers = [
                "docker-language-server"
                "yaml-language-server"
              ];
            }
            {
              name = "dockerfile";
              language-servers = [
                "docker-langserver"
                "docker-language-server"
              ];
            }
            {
              names = [
                "elixir"
                "heex"
              ];
              auto-format = true;
              language-servers = [ "expert" ];
            }
            {
              name = "git-commit";
              language-servers = [ "harper-ls" ];
            }
            {
              name = "go";
              language-servers = [
                "gopls"
                "golangci-lint-lsp"
              ];
            }
            {
              name = "graphql";
              auto-format = true;
              language-servers = [ "graphql-language-service" ];
            }
            {
              name = "html";
              auto-format = true;
              # Both servers can format, and Helix uses the first one
              language-servers = [
                "vscode-html-language-server"
                "superhtml"
              ];
            }
            {
              name = "htmldjango";
              # No superhtml, which reports template tags as errors
              language-servers = [
                "djlsp"
                "vscode-html-language-server"
              ];
              # Helix master default, remove after the next release (> 25.07.1)
              roots = [ "manage.py" ];
            }
            {
              names = [
                "javascript"
                "jsx"
                "tsx"
                "typescript"
              ];
              auto-format = true;
              language-servers = [
                "vtsls"
                "oxlint-language-server"
              ];
            }
            {
              names = [
                "json"
                "jsonc"
              ];
              auto-format = true;
              language-servers = [ "vscode-json-language-server" ];
            }
            {
              name = "just";
              auto-format = true;
              # Helix master default, remove after the next release (> 25.07.1)
              formatter = {
                command = "just";
                args = [
                  "--fmt"
                  "--justfile"
                  "-"
                ];
              };
              language-servers = [ "just-lsp" ];
            }
            {
              name = "lua";
              auto-format = true;
              formatter = {
                command = "stylua";
                args = [ "-" ];
              };
              language-servers = [ "lua-language-server" ];
            }
            {
              name = "markdown";
              auto-format = true;
              language-servers = [
                "marksman"
                "harper-ls"
              ];
            }
            {
              name = "nginx";
              language-servers = [ "nginx-language-server" ];
            }
            {
              name = "nix";
              auto-format = true;
              # Helix master default, remove after the next release (> 25.07.1)
              formatter.command = "nixfmt";
              language-servers = [ "nixd" ];
            }
            {
              name = "python";
              auto-format = true;
              language-servers = [
                "ty"
                "ruff"
              ];
            }
            {
              name = "rust";
              language-servers = [ "rust-analyzer" ];
            }
            {
              name = "toml";
              auto-format = true;
              language-servers = [ "tombi" ];
            }
            {
              name = "yaml";
              auto-format = true;
              language-servers = [ "yaml-language-server" ];
            }
            {
              name = "zig";
              language-servers = [ "zls" ];
            }
          ];

          languageNames = map (lang: lang.name) languages;

          # harper-ls checks the spelling of prose languages, so they skip typos
          codeLanguages = lib.subtractLists [
            "git-commit"
            "markdown"
          ] languageNames;

          oxfmt = {
            name = "oxfmt-language-server";
            only-features = [ "format" ];
          };

          oxfmtLanguages = [
            "css"
            "docker-compose"
            "graphql"
            "javascript"
            "json"
            "jsonc"
            "jsx"
            "markdown"
            "scss"
            "toml"
            "tsx"
            "typescript"
            "yaml"
          ];

          tailwindLanguages = [
            "css"
            "html"
            "htmldjango"
            "javascript"
            "jsx"
            "scss"
            "tsx"
            "typescript"
          ];
        in
        {
          enable = true;

          languages = {
            language = lib.pipe languages [
              # Helix formats with the first server in the list that can format
              (addServers oxfmtLanguages { first = [ oxfmt ]; })
              (addServers tailwindLanguages { last = [ "tailwindcss-ls" ]; })
              (addServers codeLanguages { last = [ "typos" ]; })
            ];

            language-server = {
              docker-language-server = {
                # Helix master defines `args` and `command`, remove them after
                # the next release (> 25.07.1)
                args = [
                  "start"
                  "--stdio"
                ];

                command = "docker-language-server";

                config.telemetry = "off";
              };

              # Helix master default, remove after the next release (> 25.07.1)
              expert = {
                args = [ "--stdio" ];

                command = "expert";
              };

              # Helix master default, remove after the next release (> 25.07.1)
              nginx-language-server.command = "nginx-language-server";

              # Helix master default, remove after the next release (> 25.07.1)
              oxfmt-language-server = {
                args = [ "--lsp" ];

                command = "oxfmt";
              };

              # Helix master default, remove after the next release (> 25.07.1)
              oxlint-language-server = {
                args = [ "--lsp" ];

                command = "oxlint";
              };

              typos.command = "typos-lsp";

              # Helix master default, remove after the next release (> 25.07.1)
              vtsls = {
                args = [ "--stdio" ];

                command = "vtsls";

                config.vtsls.autoUseWorkspaceTsdk = true;
              };
            };
          };

          settings = {
            editor.line-number = "relative";

            theme = "catppuccin_macchiato";
          };
        };
    };
}
