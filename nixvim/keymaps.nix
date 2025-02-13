{...}: {
  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  keymaps = [
    {
      mode = "n";
      key = ";";
      action = ":";
    }
    {
      mode = "n";
      key = ":";
      action = ";";
    }
  ];
}
