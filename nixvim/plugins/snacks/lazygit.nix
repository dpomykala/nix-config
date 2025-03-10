{lib, ...}: let
  inherit (lib.custom.nixvim) nCmdMap;
in {
  plugins.snacks.settings.lazygit.enabled = true;

  keymaps = [
    # NOTE: Requires LazyGit with an initialized config file
    (nCmdMap {
      key = "<Leader>gg";
      cmd = "lua Snacks.lazygit.open()";
      desc = "Open LazyGit";
    })
  ];
}
