{lib, ...}: let
  inherit (lib.custom.nixvim) nxCmdMap nxMap;
in {
  plugins.snacks.settings.gitbrowse.enabled = true;

  keymaps = [
    (nxCmdMap {
      key = "<Leader>go";
      cmd = "lua Snacks.gitbrowse.open()";
      desc = "Open in browser";
    })
    (nxMap {
      key = "<Leader>gy";
      action.__raw = ''
        function()
          Snacks.gitbrowse(
            {open = function(url) vim.fn.setreg("+", url) end, notify = false}
          )
        end
      '';
      desc = "Copy link";
    })
  ];
}
