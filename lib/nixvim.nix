{lib}: rec {
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
}
