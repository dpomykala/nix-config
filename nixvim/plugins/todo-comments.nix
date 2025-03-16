{
  config,
  lib,
  ...
}: {
  plugins.todo-comments = {
    enable = true;

    settings = {
      highlight.keyword = "bg";
    };
  };

  # TODO: Add keymaps for :TodoQuickFix and :TodoLocList
  # TODO: Add keymaps for next/prev TODO?
  keymaps = let
    inherit (lib.custom.nixvim) hasSnacksModule nCmdMap;

    hasSnacksPicker = hasSnacksModule config "picker";
  in
    lib.optionals hasSnacksPicker [
      (nCmdMap {
        key = "<Leader>fT";
        cmd = "lua Snacks.picker.todo_comments({keywords = {'TODO', 'FIX', 'FIXME'}})";
        desc = "TODOs (strict)";
      })
      (nCmdMap {
        key = "<Leader>ft";
        cmd = "lua Snacks.picker.todo_comments()";
        desc = "TODOs";
      })
    ];
}
