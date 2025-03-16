{
  lib,
  pkgs,
  ...
}: {
  plugins.snacks.settings.lazygit.enabled = true;

  extraPackages = with pkgs; [lazygit];

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    # NOTE: Requires Lazygit with an initialized config file
    (nCmdMap {
      key = "<Leader>gg";
      cmd = "lua Snacks.lazygit.open()";
      desc = "Open Lazygit";
    })
  ];
}
