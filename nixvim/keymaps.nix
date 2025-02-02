{...}: {
  keymaps = [
    # mini.map
    {
      action = "<Cmd>lua MiniMap.toggle()<CR>";
      key = "<leader>mt";
      mode = "n";
    }

    # mini.pick
    {
      action = "<Cmd>Pick buffers<CR>";
      key = "<leader>fb";
      mode = "n";
    }
    {
      action = "<Cmd>Pick files<CR>";
      key = "<leader>ff";
      mode = "n";
    }
    {
      action = "<Cmd>Pick grep_live<CR>";
      key = "<leader>fg";
      mode = "n";
    }
    {
      action = "<Cmd>Pick help<CR>";
      key = "<leader>fh";
      mode = "n";
    }
    {
      action = "<Cmd>Pick marks<CR>";
      key = "<leader>fm";
      mode = "n";
    }
    {
      action = "<Cmd>Pick keymaps<CR>";
      key = "<leader>fk";
      mode = "n";
    }
    {
      action = "<Cmd>Pick options<CR>";
      key = "<leader>fo";
      mode = "n";
    }
  ];
}
