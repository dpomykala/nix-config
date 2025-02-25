{lib, ...}: {
  plugins.noice = {
    enable = true;

    settings = {
      lsp = {
        override = lib.nixvim.toRawKeys {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
      };
      presets = {
        long_message_to_split = true;
        # Add a border to hover docs and signature help
        lsp_doc_border = true;
      };
      routes = [
        # Show messages when recording macros
        {
          view = "notify";
          filter.event = "msg_showmode";
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<Leader>na";
      action = "<Cmd>Noice all<CR>";
      options.desc = "History (all)";
    }
    {
      mode = "n";
      key = "<Leader>nd";
      action = "<Cmd>Noice dismiss<CR>";
      options.desc = "Dismiss all";
    }
    {
      mode = "n";
      key = "<Leader>nD";
      action = "<Cmd>Noice disable<CR>";
      options.desc = "Disable";
    }
    {
      mode = "n";
      key = "<Leader>ne";
      action = "<Cmd>Noice errors<CR>";
      options.desc = "Errors";
    }
    {
      mode = "n";
      key = "<Leader>nE";
      action = "<Cmd>Noice enable<CR>";
      options.desc = "Enable";
    }
    {
      mode = "n";
      key = "<Leader>nh";
      action = "<Cmd>Noice history<CR>";
      options.desc = "History";
    }
    {
      mode = "n";
      key = "<Leader>nl";
      action = "<Cmd>Noice last<CR>";
      options.desc = "Last message";
    }
    {
      mode = "c";
      key = "<S-CR>";
      action.__raw = ''
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end
      '';
      options.desc = "Redirect Cmdline";
    }
  ];
}
