{lib, ...}: let
  inherit (lib.custom.nixvim) nCmdMap nxCmdMap;
in {
  plugins.snacks.settings = {
    # FIXME: Do I need this?
    git.enabled = true;
    gitbrowse.enabled = true;
    lazygit.enabled = true;
  };

  # TODO: Add mapping for `Snacks.git.blame_line()`?
  keymaps = [
    (nxCmdMap {
      key = "<Leader>ge";
      cmd = "lua Snacks.gitbrowse.open()";
      desc = "Explore in a browser";
    })
    # NOTE: Requires LazyGit with an initialized config file
    (nCmdMap {
      key = "<Leader>gg";
      cmd = "lua Snacks.lazygit.open()";
      desc = "Open LazyGit";
    })
  ];
}
