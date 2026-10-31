_: {
  flake.modules.homeManager.zig = { lib, ... }: {
    programs.mise = {
      enable = lib.mkDefault true;

      # zls works only with the Zig release of the same version, so pin both
      globalConfig.tools = {
        zig = "0.17";
        zls = "0.17";
      };
    };
  };
}
