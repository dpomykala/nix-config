{lib}: rec {
  inherit (lib) attrByPath;

  mkCmdMap = mode: {
    key,
    cmd,
    desc ? "",
  }: {
    mode = mode;
    key = key;
    action = "<Cmd>${cmd}<CR>";
    options.desc = desc;
  };

  mkNormCmdMap = mkCmdMap "n";

  /*
  Check if the given module from the snacks.nvim plugin is enabled.
  */
  hasSnacksModule = config: module:
    config.plugins.snacks.enable
    && attrByPath ["${module}" "enabled"] false config.plugins.snacks.settings;
}
