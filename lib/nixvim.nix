{lib}: let
  inherit (lib) attrByPath;
in rec {
  mkMapper = {
    mode ? "n",
    action_prefix ? "",
    action_suffix ? "",
  }: {
    key,
    action,
    desc ? "",
  }: {
    inherit key mode;

    action =
      if lib.any (item: item != "") [action_prefix action_suffix]
      # If prefix or suffix specified - concatenate strings
      then lib.concatStrings [action_prefix action action_suffix]
      # Otherwise, leave as is (it may be raw lua code)
      else action;

    options.desc = desc;
  };

  mkCmdMapper = mode: {
    key,
    cmd,
    desc ? "",
  }:
    mkMapper {
      inherit mode;
      action_prefix = "<Cmd>";
      action_suffix = "<CR>";
    } {
      inherit key desc;
      action = cmd;
    };

  cMap = mkMapper {mode = "c";};
  iMap = mkMapper {mode = "i";};
  nMap = mkMapper {};
  xMap = mkMapper {mode = "x";};
  nxMap = mkMapper {mode = ["n" "x"];};

  cCmdMap = mkCmdMapper "c";
  nCmdMap = mkCmdMapper "n";
  xCmdMap = mkCmdMapper "x";
  noxCmdMap = mkCmdMapper ["n" "o" "x"];
  nxCmdMap = mkCmdMapper ["n" "x"];
  oCmdMap = mkCmdMapper ["o"];
  oxCmdMap = mkCmdMapper ["o" "x"];

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
