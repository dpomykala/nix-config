{lib, ...}: {
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  keymaps = let
    inherit (lib.custom.nixvim) iMap nCmdMap nMap nxMap xMap;
  in [
    # Enter the command mode with `;`
    (nxMap {
      key = ";";
      action = ":";
    })
    (nxMap {
      key = ":";
      action = ";";
    })

    # Maintain visual selection when changing indentation
    (xMap {
      key = "<";
      action = "<gv";
    })
    (xMap {
      key = ">";
      action = ">gv";
    })

    # Stop the highlighting of search results
    (nCmdMap {
      key = "<Esc>";
      cmd = "nohlsearch";
    })

    # Center a view and open folds when searching or scrolling
    (nMap {
      key = "n";
      action = "nzzzv";
    })
    (nMap {
      key = "N";
      action = "Nzzzv";
    })
    (nMap {
      key = "<C-d>";
      action = "<C-d>zzzv";
    })
    (nMap {
      key = "<C-u>";
      action = "<C-u>zzzv";
    })
    (nMap {
      key = "<C-f>";
      action = "<C-f>zzzv";
    })
    (nMap {
      key = "<C-b>";
      action = "<C-b>zzzv";
    })

    # Use H and L to move to the start or end of the line
    (nMap {
      key = "H";
      action = "^";
    })
    (nMap {
      key = "L";
      action = "$";
    })

    # Add a semicolon at the EOL and return to the previous position
    (iMap {
      key = "<M-;>";
      action = "<Esc>m`A;<Esc>``a";
    })
    (nMap {
      key = "<M-;>";
      action = "m`A;<Esc>``";
    })
    # Add a comma at the EOL and return to the previous position
    (iMap {
      key = "<M-,>";
      action = "<Esc>m`A,<Esc>``a";
    })
    (nMap {
      key = "<M-,>";
      action = "m`A,<Esc>``";
    })

    # Show diagnostics for the current line
    (nCmdMap {
      key = "<Leader>cd";
      cmd = "lua vim.diagnostic.open_float()";
      desc = "Diagnostics (line)";
    })
  ];
}
