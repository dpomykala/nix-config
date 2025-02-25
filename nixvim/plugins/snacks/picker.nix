{lib, ...}: {
  plugins.snacks.settings.picker = {
    enabled = true;
  };

  # NOTE: Some picker keymaps may be defined in other places (e.g. LSP config)
  keymaps = let
    inherit (lib.custom.nixvim) mkNormCmdMap;
  in [
    (mkNormCmdMap {
      key = "<Leader>f;";
      cmd = "lua Snacks.picker.command_history()";
      desc = "Command history";
    })
    (mkNormCmdMap {
      key = "<Leader>f/";
      cmd = "lua Snacks.picker.search_history()";
      desc = "Search history";
    })
    (mkNormCmdMap {
      key = "<Leader>f'";
      cmd = "lua Snacks.picker.marks()";
      desc = "Marks";
    })
    (mkNormCmdMap {
      key = "<Leader>f\"";
      cmd = "lua Snacks.picker.registers()";
      desc = "Registers";
    })
    (mkNormCmdMap {
      key = "<Leader>f<CR>";
      cmd = "lua Snacks.picker.resume()";
      desc = "Resume";
    })
    (mkNormCmdMap {
      key = "<Leader>fa";
      cmd = "lua Snacks.picker.autocmds()";
      desc = "Autocommands";
    })
    (mkNormCmdMap {
      key = "<Leader>fb";
      cmd = "lua Snacks.picker.buffers()";
      desc = "Buffers";
    })
    (mkNormCmdMap {
      key = "<Leader>fC";
      cmd = "lua Snacks.picker.colorschemes()";
      desc = "Colorschemes";
    })
    (mkNormCmdMap {
      key = "<Leader>fc";
      cmd = "lua Snacks.picker.commands()";
      desc = "Commands";
    })
    (mkNormCmdMap {
      key = "<Leader>fD";
      cmd = "lua Snacks.picker.diagnostics()";
      desc = "Diagnostics (cwd)";
    })
    (mkNormCmdMap {
      key = "<Leader>fd";
      cmd = "lua Snacks.picker.diagnostics_buffer()";
      desc = "Diagnostics (buffer)";
    })
    (mkNormCmdMap {
      key = "<Leader>fF";
      cmd = "lua Snacks.picker.files()";
      desc = "Files";
    })
    (mkNormCmdMap {
      key = "<Leader>ff";
      cmd = "lua Snacks.picker.smart()";
      desc = "Files (smart)";
    })
    (mkNormCmdMap {
      key = "<Leader>fg";
      cmd = "lua Snacks.picker.grep()";
      desc = "Grep";
    })
    (mkNormCmdMap {
      key = "<Leader>fH";
      cmd = "lua Snacks.picker.highlights()";
      desc = "Highlights";
    })
    (mkNormCmdMap {
      key = "<Leader>fh";
      cmd = "lua Snacks.picker.help()";
      desc = "Help";
    })
    (mkNormCmdMap {
      key = "<Leader>fi";
      cmd = "lua Snacks.picker.icons()";
      desc = "Icons";
    })
    (mkNormCmdMap {
      key = "<Leader>fj";
      cmd = "lua Snacks.picker.jumps()";
      desc = "Jumps";
    })
    (mkNormCmdMap {
      key = "<Leader>fk";
      cmd = "lua Snacks.picker.keymaps()";
      desc = "Keymaps";
    })
    (mkNormCmdMap {
      key = "<Leader>fL";
      cmd = "lua Snacks.picker.loclist()";
      desc = "Location list";
    })
    (mkNormCmdMap {
      key = "<Leader>fl";
      cmd = "lua Snacks.picker.lines()";
      desc = "Buffer lines";
    })
    # FIXME: Does not work?
    (mkNormCmdMap {
      key = "<Leader>fm";
      cmd = "lua Snacks.picker.man()";
      desc = "Man pages";
    })
    # FIXME: Does not work?
    (mkNormCmdMap {
      key = "<Leader>fn";
      cmd = "lua Snacks.picker.notifications()";
      desc = "Notifications";
    })
    (mkNormCmdMap {
      key = "<Leader>fo";
      cmd = "lua Snacks.picker.grep_buffers()";
      desc = "Grep (open buffers)";
    })
    (mkNormCmdMap {
      key = "<Leader>fP";
      cmd = "lua Snacks.picker.pickers()";
      desc = "Pickers";
    })
    (mkNormCmdMap {
      key = "<Leader>fp";
      cmd = "lua Snacks.picker.projects()";
      desc = "Projects";
    })
    (mkNormCmdMap {
      key = "<Leader>fq";
      cmd = "lua Snacks.picker.qflist()";
      desc = "Quickfix list";
    })
    (mkNormCmdMap {
      key = "<Leader>fr";
      cmd = "lua Snacks.picker.recent()";
      desc = "Recent files";
    })
    (mkNormCmdMap {
      key = "<Leader>fs";
      cmd = "lua Snacks.picker.spelling()";
      desc = "Spelling";
    })
    (mkNormCmdMap {
      key = "<Leader>fu";
      cmd = "lua Snacks.picker.undo()";
      desc = "Undotree";
    })
    (mkNormCmdMap {
      key = "<Leader>fw";
      cmd = "lua Snacks.picker.grep_word()";
      desc = "Grep for word";
    })
    (mkNormCmdMap {
      key = "<Leader>fz";
      cmd = "lua Snacks.picker.zoxide()";
      desc = "Files (zoxide)";
    })
  ];
}
