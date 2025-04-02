{
  config,
  lib,
  ...
}: {
  plugins.mini.modules.clue = let
    inherit (lib.custom.nixvim) hasMiniModule hasSnacksModule;

    # Generate clues or triggers
    genMiniClueAttrs = {
      mode,
      keys,
      desc ? null,
    }:
      lib.concatMap (
        mode:
          map (
            keys:
              {inherit mode keys;}
              // lib.optionalAttrs (desc != null) {inherit desc;}
          )
          (lib.toList keys)
      )
      (lib.toList mode);

    # Generate clues for submodes
    genSubmodeClues = {
      mode,
      postKeys,
      submodeKey,
    }:
      lib.concatMap (
        mode:
          lib.concatMap (
            postkeys:
              map (submodeKey: {
                inherit mode postkeys;
                keys = postkeys + submodeKey;
              })
              (lib.toList submodeKey)
          )
          (lib.toList postKeys)
      )
      (lib.toList mode);

    hasMiniBracketed = hasMiniModule config "bracketed";
    hasMiniFiles = hasMiniModule config "files";
    hasMiniMap = hasMiniModule config "map";
    hasMiniSurround = hasMiniModule config "surround";
    hasSnacksBufdelete = hasSnacksModule config "bufdelete";
    hasSnacksExplorer = hasSnacksModule config "explorer";
    hasSnacksGit = hasSnacksModule config "git";
    hasSnacksGitbrowse = hasSnacksModule config "gitbrowse";
    hasSnacksLazygit = hasSnacksModule config "lazygit";
    hasSnacksPicker = hasSnacksModule config "picker";
    hasSnacksRename = hasSnacksModule config "rename";
    hasSnacksScratch = hasSnacksModule config "scratch";
  in {
    clues =
      lib.flatten [
        # Generate pre-configured clues
        {__raw = "require('mini.clue').gen_clues.builtin_completion()";}
        {__raw = "require('mini.clue').gen_clues.g()";}
        {__raw = "require('mini.clue').gen_clues.marks()";}
        {__raw = "require('mini.clue').gen_clues.registers()";}
        {
          __raw = ''
            require('mini.clue').gen_clues.windows(
              { submode_move = true, submode_navigate = true, submode_resize = true }
            )
          '';
        }
        {__raw = "require('mini.clue').gen_clues.z()";}

        # Descriptions for <Leader> mapping groups
        (lib.optional (hasSnacksBufdelete || hasSnacksScratch) {
          mode = "n";
          keys = "<Leader>b";
          desc = "+Buffer";
        })
        (genMiniClueAttrs {
          mode = ["n" "x"];
          keys = "<Leader>c";
          desc = "+Code";
        })
        (lib.optional (
            hasMiniFiles || hasSnacksExplorer || hasSnacksRename
          ) {
            mode = "n";
            keys = "<Leader>e";
            desc = "+Edit";
          })
        (lib.optionals (
            hasSnacksGitbrowse || hasSnacksLazygit || hasSnacksPicker
          )
          genMiniClueAttrs {
            mode = ["n" "x"];
            keys = "<Leader>g";
            desc = "+Git";
          })
        (lib.optionals (
            config.plugins.todo-comments.enable || hasSnacksPicker
          )
          genMiniClueAttrs {
            mode = ["n" "x"];
            keys = "<Leader>f";
            desc = "+Find";
          })
        (lib.optional config.plugins.lsp.enable {
          mode = "n";
          keys = "<Leader>l";
          desc = "+LSP";
        })
        (lib.optional hasMiniMap {
          mode = "n";
          keys = "<Leader>m";
          desc = "+Map";
        })
        (lib.optional config.plugins.noice.enable {
          mode = "n";
          keys = "<Leader>n";
          desc = "+Noice";
        })
        (lib.optionals config.plugins.grug-far.enable genMiniClueAttrs {
          mode = ["n" "x"];
          keys = "<Leader>r";
          desc = "+Replace";
        })
        (lib.optional config.plugins.persistence.enable {
          mode = "n";
          keys = "<Leader>s";
          desc = "+Session";
        })

        # Custom mapping groups
        (lib.optionals (
            config.plugins.gitsigns.enable || hasSnacksGit
          )
          genMiniClueAttrs {
            mode = ["n" "x"];
            keys = "gh";
            desc = "+Git hunks";
          })
        (lib.optionals config.plugins.lsp.enable genMiniClueAttrs {
          mode = ["n" "x"];
          keys = "gl";
          desc = "+LSP";
        })
        (lib.optionals hasMiniSurround genMiniClueAttrs {
          mode = ["n" "x"];
          keys = "gs";
          desc = "Surround";
        })
        {
          mode = "n";
          keys = "\\g";
          desc = "+Toggle Git options";
        }
      ]
      ++ lib.optionals hasMiniBracketed genSubmodeClues {
        mode = "n";
        postKeys = ["[" "]"];
        submodeKey = ["b" "c" "d" "h" "j" "q" "u" "w"];
      };

    triggers = lib.flatten [
      # Leader triggers
      (genMiniClueAttrs {
        mode = ["n" "x"];
        keys = "<Leader>";
      })

      # Local leader triggers
      (genMiniClueAttrs {
        mode = ["n" "x"];
        keys = "<Localleader>";
      })

      # Built-in completion
      {
        mode = "i";
        keys = "<C-x>";
      }

      # `g` key
      (genMiniClueAttrs {
        mode = ["n" "o" "x"];
        keys = "g";
      })

      # Marks
      (genMiniClueAttrs {
        mode = ["n" "x"];
        keys = ["'" "`"];
      })

      # Backward / Forward (e.g. mappings from mini.bracketed)
      (genMiniClueAttrs {
        mode = ["n" "o" "x"];
        keys = ["[" "]"];
      })

      # Registers
      (genMiniClueAttrs {
        mode = ["n" "x"];
        keys = "\"";
      })
      (genMiniClueAttrs {
        mode = ["c" "i"];
        keys = "<C-r>";
      })

      # Toggling options (e.g. mappings from mini.basics)
      {
        mode = "n";
        keys = "\\";
      }

      # Window commands
      {
        mode = "n";
        keys = "<C-w>";
      }

      # `z` key
      (genMiniClueAttrs {
        mode = ["n" "x"];
        keys = "z";
      })
    ];

    window = {
      config = {width = "auto";};
      delay = 500;
    };
  };
}
