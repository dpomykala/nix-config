{...}: {
  plugins.flash = {
    enable = true;
  };

  keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      action = "<Cmd>lua require('flash').jump()<CR>";
      options = {desc = "Flash";};
    }
    {
      mode = ["n" "x" "o"];
      key = "S";
      action = "<Cmd>lua require('flash').treesitter()<CR>";
      options = {desc = "Flash Treesitter";};
    }
    {
      mode = "o";
      key = "r";
      action = "<Cmd>lua require('flash').remote()<CR>";
      options = {desc = "Remote Flash";};
    }
    {
      mode = ["x" "o"];
      key = "R";
      action = "<Cmd>lua require('flash').treesitter_search()<CR>";
      options = {desc = "Treesitter Search";};
    }
    {
      mode = "c";
      key = "<C-s>";
      action = "<Cmd>lua require('flash').toggle()<CR>";
      options = {desc = "Toggle Flash Search";};
    }
  ];
}
