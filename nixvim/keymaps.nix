{...}: {
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  keymaps = [
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

    # Stop the highlighting of search matches
    {
      mode = "n";
      key = "<Esc>";
      action = "<Cmd>nohlsearch<CR>";
    }
  ];
}
