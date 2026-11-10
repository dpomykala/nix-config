_: {
  flake.modules.homeManager.superfile =
    { config, lib, ... }:
    {
      programs.superfile = {
        enable = true;

        # Only the hotkeys that differ from the default ones
        hotkeys = {
          copy_items = [ "y" ];

          copy_path = [ "Y" ];

          cut_items = [ "x" ];

          delete_items = [ "d" ];

          file_panel_item_create = [ "a" ];

          file_panel_item_rename = [ "r" ];

          focus_on_metadata = [ "ctrl+g" ];

          focus_on_process_bar = [ "ctrl+p" ];

          focus_on_sidebar = [ "ctrl+s" ];

          page_down = [ "ctrl+d" ];

          page_up = [ "ctrl+u" ];

          paste_items = [ "p" ];

          previous_file_panel = [
            "H"
            "shift+tab"
          ];
        };

        settings = {
          # Home Manager writes only the keys set here, in both the config and
          # the hotkeys file, so silence the startup warning about the missing
          # ones
          ignore_missing_fields = true;

          theme = "catppuccin-macchiato";

          zoxide_support = true;
        };
      };

      # A child process cannot change the directory of the shell. When you quit
      # with `Q`, superfile writes a `cd` command to the lastdir file, and this
      # wrapper sources that file.
      programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        spf() {
          local lastdir
          lastdir="$(command superfile path-list --lastdir-file)"
          command superfile "$@"
          if [[ -f $lastdir ]]; then
            source "$lastdir"
            rm -f -- "$lastdir"
          fi
        }
      '';
    };
}
