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

        hasSnacksPicker = hasSnacksModule config "picker";
        hasSnacksLazygit = hasSnacksModule config "lazygit";
      in
        [
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }
        ]
        ++ lib.optionals hasSnacksPicker [
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action = ":lua Snacks.picker.smart()";
          }
          {
            icon = " ";
            key = "g";
            desc = "Grep Files";
            action = ":lua Snacks.picker.grep()";
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent Files";
            action = ":lua Snacks.picker.recent()";
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

    sections = [
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
      {
        icon = " ";
        title = "Projects";
        section = "projects";
        padding = 1;
      }
    ];
  };
}
