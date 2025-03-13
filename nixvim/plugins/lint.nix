{
  lib,
  pkgs,
  ...
}: {
  plugins.lint = {
    enable = true;

    autoCmd.callback.__raw = ''
      function(args)
        -- Disable automatic linting with a global or buffer-local variable
        if vim.g.autolint_disable or vim.b[args.buf].autolint_disable then
          return
        end
        require('lint').try_lint()
      end
    '';

    lintersByFt = {
      nix = ["statix"];
    };
  };

  extraPackages = with pkgs; [
    statix
  ];

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>cl";
      cmd = "lua require('lint').try_lint()";
      desc = "Lint file";
    })
    (nCmdMap {
      key = "\\A";
      cmd = "AutolintToggle";
      desc = "Toggle linting";
    })
    (nCmdMap {
      key = "\\a";
      cmd = "AutolintBufferToggle";
      desc = "Toggle linting (buffer)";
    })
  ];

  userCommands = {
    AutolintToggle = {
      command.__raw = ''
        function()
          vim.g.autolint_disable = not vim.g.autolint_disable
          local status = not vim.g.autolint_disable and "enabled" or "disabled"
          print("Auto-linting (global): " .. status)
        end
      '';
      desc = "Toggle automatic linting (globally)";
    };

    AutolintBufferToggle = {
      command.__raw = ''
        function()
          vim.b.autolint_disable = not vim.b.autolint_disable
          local status = not vim.b.autolint_disable and "enabled" or "disabled"
          print("Auto-linting (buffer): " .. status)
        end
      '';
      desc = "Toggle automatic linting for the current buffer";
    };
  };
}
