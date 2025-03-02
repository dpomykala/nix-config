{lib, ...}: {
  plugins.lint = {
    enable = true;

    lintersByFt = {
      nix = ["statix"];
    };
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>cl";
      cmd = "lua require('lint').try_lint()";
      desc = "Lint file";
    })
  ];

  # TODO: Add auto-linting with autocommands?
}
