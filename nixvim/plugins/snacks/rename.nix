{lib, ...}: {
  plugins.snacks.settings.rename.enable = true;

  autoCmd = [
    {
      event = "User";
      pattern = "MiniFilesActionRename";
      callback.__raw = ''
        function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end
      '';
    }
  ];

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>er";
      cmd = "lua Snacks.rename.rename_file()";
      desc = "Rename current file";
    })
  ];
}
