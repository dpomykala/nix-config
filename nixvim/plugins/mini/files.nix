{lib, ...}: {
  plugins.mini.modules.files = {
    windows = {
      preview = true;
      width_preview = 50;
    };
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>ef";
      cmd = "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))";
      desc = "MiniFiles (buffer)";
    })
    (nCmdMap {
      key = "<Leader>ed";
      cmd = "lua MiniFiles.open()";
      desc = "MiniFiles (cwd)";
    })
  ];
}
