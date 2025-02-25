{lib, ...}: {
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  keymaps = let
    inherit (lib.custom.nixvim) mkNormCmdMap;
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
    (mkNormCmdMap {
      key = "<Esc>";
      cmd = "nohlsearch";
    })

    # Diagnostics
    {
      mode = "x";
      key = "<Leader>df";
      action = "<C-w>d";
      options.desc = "Diagnostics (line)";
    }
    # TODO: Toggle diagnostics (enable/disable)
  ];
}
