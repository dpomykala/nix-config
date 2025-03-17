{lib, ...}: let
  localSessionFile = ".session.nvim";
in {
  plugins.mini.modules.sessions = {
    file = localSessionFile;

    # Print the loaded session path
    verbose.read = true;
  };

  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap nMap;
  in [
    (nMap {
      key = "<Leader>sa";
      action.__raw = ''
        function()
          if vim.v.this_session ~= "" then
            print("Active session: " .. vim.fs.basename(vim.v.this_session))
          else
            print("No active session")
          end
        end
      '';
      desc = "Show active";
    })
    (nMap {
      key = "<Leader>sD";
      action.__raw = ''
        function()
          if vim.v.this_session ~= "" then
            MiniSessions.delete(nil, {force = true})
          else
            print("No active session")
          end
        end
      '';
      desc = "Delete active";
    })
    (nCmdMap {
      key = "<Leader>sd";
      cmd = "lua MiniSessions.select('delete', {force = true})";
      desc = "Delete (select)";
    })
    (nCmdMap {
      key = "<Leader>sl";
      cmd = "lua MiniSessions.write('${localSessionFile}')";
      desc = "Save (local)";
    })
    # Load local session if detected or last session
    (nCmdMap {
      key = "<Leader>sr";
      cmd = "lua MiniSessions.read()";
      desc = "Restore";
    })
    (nCmdMap {
      key = "<Leader>ss";
      cmd = "lua MiniSessions.select()";
      desc = "Select";
    })
    (nMap {
      key = "<Leader>sw";
      action.__raw = ''
        function()
          -- Get the name of the currently active session (if any)
          local session_name = vim.fs.basename(vim.v.this_session)

          if session_name == "" then
            local git_root = vim.fs.root(0, ".git")

            if git_root then
              session_name = vim.fs.basename(git_root)

              local git_branch = vim.fn.systemlist("git branch --show-current")[1]
              if vim.v.shell_error == 0 then
                session_name = string.format("%s ( %s)", session_name, git_branch)
              end
            end
          end

          local on_confirm = function(input)
            if input and input ~= "" then MiniSessions.write(input) end
          end

          vim.ui.input(
            {prompt = "Session name: ", default = session_name}, on_confirm
          )
        end
      '';
      desc = "Save";
    })
  ];
}
