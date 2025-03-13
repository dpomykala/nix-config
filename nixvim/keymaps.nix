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

    # Center a view and open folds when searching or scrolling
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zzzv";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zzzv";
    }
    {
      mode = "n";
      key = "<C-f>";
      action = "<C-f>zzzv";
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<C-b>zzzv";
    }

    # Use H and L to move to the start or end of the line

    {
      mode = "n";
      key = "H";
      action = "^";
    }
    {
      mode = "n";
      key = "L";
      action = "$";
    }

    # Add a semicolon at the EOL and return to the previous position
    {
      mode = "i";
      key = "<M-;>";
      action = "<Esc>m`A;<Esc>``a";
    }
    {
      mode = "n";
      key = "<M-;>";
      action = "m`A;<Esc>``";
    }
    # Add a comma at the EOL and return to the previous position
    {
      mode = "i";
      key = "<M-,>";
      action = "<Esc>m`A,<Esc>``a";
    }
    {
      mode = "n";
      key = "<M-,>";
      action = "m`A,<Esc>``";
    }

    # Show diagnostics for the current line
    (nCmdMap {
      key = "<Leader>cd";
      cmd = "lua vim.diagnostic.open_float()";
      desc = "Diagnostics (line)";
    })
  ];
}
