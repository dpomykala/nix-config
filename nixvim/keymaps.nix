{lib, ...}: {
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    # Enter the command mode with `;`
    {
      mode = ["n" "x"];
      key = ";";
      action = ":";
    }
    {
      mode = ["n" "x"];
      key = ":";
      action = ";";
    }

    # Maintain visual selection when changing indentation
    {
      mode = "x";
      key = "<";
      action = "<gv";
    }
    {
      mode = "x";
      key = ">";
      action = ">gv";
    }

    # Stop the highlighting of search results
    (nCmdMap {
      key = "<Esc>";
      cmd = "nohlsearch";
    })

    # Add a semicolon at the EOL and return to the previous position
    {
      mode = "i";
      key = "<M-;>";
      action = "<Esc>m`A;<Esc>``a";
      options.desc = "Smart semicolon";
    }
    {
      mode = "n";
      key = "<M-;>";
      action = "m`A;<Esc>``";
      options.desc = "Smart semicolon";
    }
    # Add a comma at the EOL and return to the previous position
    {
      mode = "i";
      key = "<M-,>";
      action = "<Esc>m`A,<Esc>``a";
      options.desc = "Smart comma";
    }
    {
      mode = "n";
      key = "<M-,>";
      action = "m`A,<Esc>``";
      options.desc = "Smart comma";
    }

    # Show diagnostics for the current line
    (nCmdMap {
      key = "<Leader>cd";
      cmd = "lua vim.diagnostic.open_float()";
      desc = "Diagnostics (line)";
    })
  ];
}
