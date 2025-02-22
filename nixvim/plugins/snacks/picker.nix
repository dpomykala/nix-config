{...}: {
  plugins.snacks.settings.picker = {
    enabled = true;
  };

  keymaps = let
    mkNormCmdMap = {
      key,
      cmd,
      desc,
    }: {
      mode = "n";
      key = key;
      action = "<Cmd>${cmd}<CR>";
      options.desc = desc;
    };
  in [
    (mkNormCmdMap {
      key = "<Leader>f;";
      cmd = "lua Snacks.picker.command_history()";
      desc = "Find in command history";
    })
    (mkNormCmdMap {
      key = "<Leader>f/";
      cmd = "lua Snacks.picker.search_history()";
      desc = "Find in search history";
    })
    (mkNormCmdMap {
      key = "<Leader>f\"";
      cmd = "lua Snacks.picker.registers()";
      desc = "Find registers";
    })
    (mkNormCmdMap {
      key = "<Leader>fa";
      cmd = "lua Snacks.picker.resume()";
      desc = "Find again (resume)";
    })
    (mkNormCmdMap {
      key = "<Leader>fA";
      cmd = "lua Snacks.picker.autocmds()";
      desc = "Find autocommands";
    })
    (mkNormCmdMap {
      key = "<Leader>fb";
      cmd = "lua Snacks.picker.buffers()";
      desc = "Find buffers";
    })
    (mkNormCmdMap {
      key = "<Leader>fc";
      cmd = "lua Snacks.picker.commands()";
      desc = "Find commands";
    })
    (mkNormCmdMap {
      key = "<Leader>ff";
      cmd = "lua Snacks.picker.files()";
      desc = "Find files";
    })
    (mkNormCmdMap {
      key = "<Leader>fg";
      cmd = "lua Snacks.picker.grep()";
      desc = "Find by grep";
    })
    (mkNormCmdMap {
      key = "<Leader>fh";
      cmd = "lua Snacks.picker.help()";
      desc = "Find help";
    })
    (mkNormCmdMap {
      key = "<Leader>fk";
      cmd = "lua Snacks.picker.keymaps()";
      desc = "Find keymaps";
    })
    (mkNormCmdMap {
      key = "<Leader>fm";
      cmd = "lua Snacks.picker.marks()";
      desc = "Find marks";
    })
    # FIXME: Does not work?
    (mkNormCmdMap {
      key = "<Leader>fn";
      cmd = "lua Snacks.picker.notifications()";
      desc = "Find notifications";
    })
    (mkNormCmdMap {
      key = "<Leader>fq";
      cmd = "lua Snacks.picker.qflist()";
      desc = "Find quickfixes";
    })
    (mkNormCmdMap {
      key = "<Leader>fr";
      cmd = "lua Snacks.picker.recent()";
      desc = "Find recent files";
    })
    (mkNormCmdMap {
      key = "<Leader>fs";
      cmd = "lua Snacks.picker.smart()";
      desc = "Find files (smart)";
    })
  ];
}
