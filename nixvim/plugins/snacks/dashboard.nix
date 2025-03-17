{
  config,
  lib,
  ...
}: {
  plugins.snacks.settings.dashboard = {
    enabled = true;

    preset = {
      header = lib.concatStringsSep "\n" [
        "                     :                      "
        "                    .=.                     "
        "          =         ++:         :.          "
        "          +=       .++=        .=           "
        "          =*.      .**+        +.           "
        "          =#=      :**+       :*:           "
        "          -**:     .***       *#:           "
        "          -#*+     :***.     =#*:           "
        "          .***-    +#**:    :#*#:           "
        "           +***.   *#**-    +###:           "
        "           +**#-   ##*#=    ####=.          "
        "          :***#-   ####*   .#%##%:          "
        "          .###+    .*#*:    .%##=           "
        "           -##+     :#-     :##+            "
        "            =##-   :*#*:   :###.            "
        "             +#*   -###+   =%#:             "
        "             .*#.  .###=   +%-              "
        "              :#=  .###:   +-               "
        "                =   *#*   .-                "
        "                    -#+                     "
        "                     #-                     "
        "                     =:                     "
      ];

      keys = let
        inherit (lib.custom.nixvim) hasSnacksModule;

        hasSnacksLazygit = hasSnacksModule config "lazygit";
      in
        lib.optionals config.plugins.persistence.enable [
          {
            icon = " ";
            key = "s";
            desc = "Restore Session";
            action = ":lua require('persistence').load()";
          }
        ]
        ++ [
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }

          # Snacks.dashboard.pick() will try to use any available picker
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action = ":lua Snacks.dashboard.pick('files')";
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent Files";
            action = ":lua Snacks.dashboard.pick('oldfiles')";
          }
          {
            icon = " ";
            key = "g";
            desc = "Grep Files";
            action = ":lua Snacks.dashboard.pick('live_grep')";
          }
        ]
        ++ lib.optionals hasSnacksLazygit [
          {
            icon = "";
            key = "l";
            desc = "Lazygit";
            action = ":lua Snacks.lazygit.open()";
          }
        ]
        ++ [
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
        ];
    };

    sections = let
      projectsSection =
        {
          icon = " ";
          title = "Projects";
          section = "projects";
          padding = 1;
        }
        // lib.optionalAttrs config.plugins.persistence.enable {
          # Custom action to load project session using persistence.nvim
          action.__raw = ''
            function(dir)
              local session_loaded = false
              vim.api.nvim_create_autocmd("SessionLoadPost", {
                once = true,
                callback = function()
                  session_loaded = true
                end,
              })
              vim.defer_fn(function()
                if not session_loaded then
                  Snacks.dashboard.pick('files')
                end
              end, 100)
              vim.fn.chdir(dir)

              -- Try to restore session using persistence.nvim
              require("persistence").load()
            end
          '';
        };
    in [
      {section = "header";}
      {
        section = "keys";
        gap = 1;
        padding = 2;
      }
      {
        icon = " ";
        title = "Recent Files";
        section = "recent_files";
        padding = 1;
      }
      projectsSection
    ];
  };
}
