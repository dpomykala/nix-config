_: {
  plugins.mini.modules.indentscope = {
    symbol = "│";
    options.try_as_border = true;
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "help";
      callback.__raw = ''
        function(args)
          vim.b[args.buf].miniindentscope_disable = true
        end
      '';
      desc = "Disable MiniIndentscope in help pages";
    }

    # NOTE: This is required as disabling via the FileType event does not work
    {
      event = "User";
      pattern = "SnacksDashboardOpened";
      callback.__raw = ''
        function(args)
          vim.b[args.buf].miniindentscope_disable = true
        end
      '';
      desc = "Disable MiniIndentscope in the snacks.nvim dashboard";
    }
  ];
}
