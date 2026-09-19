{ self, ... }: {
  flake.modules.homeManager.python = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      ruff
      uv
    ];

    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools.python = "latest";
    };
  };
}
