{lib, ...}: {
  plugins.snacks.settings.picker = {
    enabled = true;
  };

  # NOTE: Some picker keymaps may be defined in other places (e.g. LSP config)
  keymaps = let
    inherit (lib.custom.nixvim) nCmdMap;
  in [
    (nCmdMap {
      key = "<Leader>f;";
      cmd = "lua Snacks.picker.command_history()";
      desc = "Command history";
    })
    (nCmdMap {
      key = "<Leader>f/";
      cmd = "lua Snacks.picker.search_history()";
      desc = "Search history";
    })
    (nCmdMap {
      key = "<Leader>f'";
      cmd = "lua Snacks.picker.marks()";
      desc = "Marks";
    })
    (nCmdMap {
      key = "<Leader>f\"";
      cmd = "lua Snacks.picker.registers()";
      desc = "Registers";
    })
    (nCmdMap {
      key = "<Leader>f<CR>";
      cmd = "lua Snacks.picker.resume()";
      desc = "Resume";
    })
    (nCmdMap {
      key = "<Leader>fa";
      cmd = "lua Snacks.picker.autocmds()";
      desc = "Autocommands";
    })
    (nCmdMap {
      key = "<Leader>fb";
      cmd = "lua Snacks.picker.buffers()";
      desc = "Buffers";
    })
    (nCmdMap {
      key = "<Leader>fC";
      cmd = "lua Snacks.picker.colorschemes()";
      desc = "Colorschemes";
    })
    (nCmdMap {
      key = "<Leader>fc";
      cmd = "lua Snacks.picker.commands()";
      desc = "Commands";
    })
    (nCmdMap {
      key = "<Leader>fD";
      cmd = "lua Snacks.picker.diagnostics()";
      desc = "Diagnostics (cwd)";
    })
    (nCmdMap {
      key = "<Leader>fd";
      cmd = "lua Snacks.picker.diagnostics_buffer()";
      desc = "Diagnostics (buffer)";
    })
    (nCmdMap {
      key = "<Leader>fF";
      cmd = "lua Snacks.picker.files()";
      desc = "Files";
    })
    (nCmdMap {
      key = "<Leader>ff";
      cmd = "lua Snacks.picker.smart()";
      desc = "Files (smart)";
    })
    (nCmdMap {
      key = "<Leader>fg";
      cmd = "lua Snacks.picker.grep()";
      desc = "Grep";
    })
    (nCmdMap {
      key = "<Leader>fH";
      cmd = "lua Snacks.picker.highlights()";
      desc = "Highlights";
    })
    (nCmdMap {
      key = "<Leader>fh";
      cmd = "lua Snacks.picker.help()";
      desc = "Help";
    })
    (nCmdMap {
      key = "<Leader>fi";
      cmd = "lua Snacks.picker.icons()";
      desc = "Icons";
    })
    (nCmdMap {
      key = "<Leader>fj";
      cmd = "lua Snacks.picker.jumps()";
      desc = "Jumps";
    })
    (nCmdMap {
      key = "<Leader>fk";
      cmd = "lua Snacks.picker.keymaps()";
      desc = "Keymaps";
    })
    (nCmdMap {
      key = "<Leader>fL";
      cmd = "lua Snacks.picker.loclist()";
      desc = "Location list";
    })
    (nCmdMap {
      key = "<Leader>fl";
      cmd = "lua Snacks.picker.lines()";
      desc = "Buffer lines";
    })
    # FIXME: Does not work?
    (nCmdMap {
      key = "<Leader>fm";
      cmd = "lua Snacks.picker.man()";
      desc = "Man pages";
    })
    # FIXME: Does not work?
    (nCmdMap {
      key = "<Leader>fn";
      cmd = "lua Snacks.picker.notifications()";
      desc = "Notifications";
    })
    (nCmdMap {
      key = "<Leader>fo";
      cmd = "lua Snacks.picker.grep_buffers()";
      desc = "Grep (open buffers)";
    })
    (nCmdMap {
      key = "<Leader>fP";
      cmd = "lua Snacks.picker.pickers()";
      desc = "Pickers";
    })
    (nCmdMap {
      key = "<Leader>fp";
      cmd = "lua Snacks.picker.projects()";
      desc = "Projects";
    })
    (nCmdMap {
      key = "<Leader>fq";
      cmd = "lua Snacks.picker.qflist()";
      desc = "Quickfix list";
    })
    (nCmdMap {
      key = "<Leader>fr";
      cmd = "lua Snacks.picker.recent()";
      desc = "Recent files";
    })
    (nCmdMap {
      key = "<Leader>fs";
      cmd = "lua Snacks.picker.spelling()";
      desc = "Spelling";
    })
    (nCmdMap {
      key = "<Leader>fu";
      cmd = "lua Snacks.picker.undo()";
      desc = "Undotree";
    })
    (nCmdMap {
      key = "<Leader>fw";
      cmd = "lua Snacks.picker.grep_word()";
      desc = "Grep for word";
    })
    (nCmdMap {
      key = "<Leader>fz";
      cmd = "lua Snacks.picker.zoxide()";
      desc = "Files (zoxide)";
    })
  ];
}
