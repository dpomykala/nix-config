{lib, ...}: let
  inherit (lib.custom.nixvim) nCmdMap;
in {
  plugins.snacks.settings.git.enabled = true;

  keymaps = [
    (nCmdMap {
      key = "ghl";
      cmd = "lua Snacks.git.blame_line()";
      desc = "Blame line (float)";
    })
  ];
}
