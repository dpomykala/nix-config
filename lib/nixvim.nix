{lib}: let
  inherit (lib) attrByPath;
in rec {
  mkCmdMap = mode: {
    key,
    cmd,
    desc ? "",
  }: {
    inherit key mode;
    action = "<Cmd>${cmd}<CR>";
    options.desc = desc;
  };

  nCmdMap = mkCmdMap "n";
  xCmdMap = mkCmdMap "x";
  nxCmdMap = mkCmdMap ["n" "x"];

  /*
  Check if the given module from the snacks.nvim plugin is enabled.
  */
  hasSnacksModule = config: module:
    config.plugins.snacks.enable
    && attrByPath ["${module}" "enabled"] false config.plugins.snacks.settings;

  /*
  Check if the given module from the mini.nvim plugin is enabled.
  */
  hasMiniModule = config: module:
    config.plugins.mini.enable && config.plugins.mini.modules ? ${module};
}
