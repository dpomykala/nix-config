{...}: {
  plugins.mini.modules.pick = {};

  keymaps = [
    {
      mode = "n";
      key = "<Leader>fb";
      action = "<Cmd>Pick buffers<CR>";
      options = {desc = "Find buffers";};
    }
    {
      mode = "n";
      key = "<Leader>ff";
      action = "<Cmd>Pick files<CR>";
      options = {desc = "Find files";};
    }
    {
      mode = "n";
      key = "<Leader>fg";
      action = "<Cmd>Pick grep_live<CR>";
      options = {desc = "Find by grep";};
    }
    {
      mode = "n";
      key = "<Leader>fh";
      action = "<Cmd>Pick help<CR>";
      options = {desc = "Find help";};
    }
    {
      mode = "n";
      key = "<Leader>fm";
      action = "<Cmd>Pick marks<CR>";
      options = {desc = "Find marks";};
    }
    {
      mode = "n";
      key = "<Leader>fk";
      action = "<Cmd>Pick keymaps<CR>";
      options = {desc = "Find keymaps";};
    }
    {
      mode = "n";
      key = "<Leader>fo";
      action = "<Cmd>Pick options<CR>";
      options = {desc = "Find options";};
    }
  ];
}
