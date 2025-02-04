{...}: {
  plugins.mini.modules.pick = {};

  keymaps = [
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Pick buffers<CR>";
      options = {desc = "Find buffers";};
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Pick files<CR>";
      options = {desc = "Find files";};
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Pick grep_live<CR>";
      options = {desc = "Find by grep";};
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Pick help<CR>";
      options = {desc = "Find help";};
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = "<cmd>Pick marks<CR>";
      options = {desc = "Find marks";};
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = "<cmd>Pick keymaps<CR>";
      options = {desc = "Find keymaps";};
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Pick options<CR>";
      options = {desc = "Find options";};
    }
  ];
}
