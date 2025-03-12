{lib, ...}: {
  plugins.snacks.settings.git.enabled = true;

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "ghl";
      cmd = "lua Snacks.git.blame_line()";
      desc = "Blame line (float)";
    })
  ];
}
