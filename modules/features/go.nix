_: {
  flake.modules.homeManager.go = { lib, ... }: {
    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools.go = "latest";
    };
  };
}
