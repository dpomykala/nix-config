{...}: {
  plugins.mini.modules.clue = {
    clues = [
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
      {
        mode = "n";
        keys = "<Leader>b";
        desc = "+Buffer";
      }
      {
        mode = "n";
        keys = "<Leader>c";
        desc = "+Code";
      }
      {
        mode = "x";
        keys = "<Leader>c";
        desc = "+Code";
      }
      {
        mode = "n";
        keys = "<Leader>e";
        desc = "+Explore";
      }
      {
        mode = "n";
        keys = "<Leader>g";
        desc = "+Git";
      }
      {
        mode = "n";
        keys = "<Leader>f";
        desc = "+Find";
      }
      {
        mode = "x";
        keys = "<Leader>f";
        desc = "+Find";
      }
      {
        mode = "n";
        keys = "<Leader>l";
        desc = "+LSP";
      }
      {
        mode = "n";
        keys = "<Leader>m";
        desc = "+Map";
      }
      {
        mode = "n";
        keys = "<Leader>n";
        desc = "+Noice";
      }

      # Custom mappings
      {
        mode = "n";
        keys = "gl";
        desc = "+LSP";
      }
      {
        mode = "x";
        keys = "gl";
        desc = "+LSP";
      }
      {
        mode = "n";
        keys = "gs";
        desc = "Surround";
      }
      {
        mode = "x";
        keys = "gs";
        desc = "Surround";
      }

      # Submodes for previous / next (mini.bracketed)
      {
        mode = "n";
        keys = "]b";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[b";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]w";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[w";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]c";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[c";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]d";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[d";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]h";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[h";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]j";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[j";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]q";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[q";
        postkeys = "[";
      }
      {
        mode = "n";
        keys = "]u";
        postkeys = "]";
      }
      {
        mode = "n";
        keys = "[u";
        postkeys = "[";
      }
    ];

    triggers = [
      # Leader triggers
      {
        mode = "n";
        keys = "<Leader>";
      }
      {
        mode = "x";
        keys = "<Leader>";
      }

      # Built-in completion
      {
        mode = "i";
        keys = "<C-x>";
      }

      # `g` key
      {
        mode = "n";
        keys = "g";
      }
      {
        mode = "x";
        keys = "g";
      }

      # Marks
      {
        mode = "n";
        keys = "'";
      }
      {
        mode = "n";
        keys = "`";
      }
      {
        mode = "x";
        keys = "'";
      }
      {
        mode = "x";
        keys = "`";
      }

      # Previous / next (mini.bracketed)
      {
        mode = "n";
        keys = "[";
      }
      {
        mode = "x";
        keys = "[";
      }
      {
        mode = "n";
        keys = "]";
      }
      {
        mode = "x";
        keys = "[";
      }

      # Registers
      {
        mode = "n";
        keys = "\"";
      }
      {
        mode = "x";
        keys = "\"";
      }
      {
        mode = "i";
        keys = "<C-r>";
      }
      {
        mode = "c";
        keys = "<C-r>";
      }

      # Toggling options (mini.basics)
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
      {
        mode = "n";
        keys = "z";
      }
      {
        mode = "x";
        keys = "z";
      }
    ];

    window = {
      config = {width = "auto";};
      delay = 500;
    };
  };
}
