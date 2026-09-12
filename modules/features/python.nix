{ self, ... }: {
  flake.modules.homeManager.python = { pkgs, ... }: {
    imports = [ self.modules.homeManager.mise ];

    home.packages = with pkgs; [
      ruff
      uv
    ];

    programs.mise.globalConfig.tools = {
      python = "latest";
    };
  };
}
