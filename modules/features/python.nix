_: {
  flake.modules.homeManager.python =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home = {
        packages = with pkgs; [
          ruff
          uv
        ];

        shellAliases = {
          cl-pyc = "find ./ -name '*.pyc' -delete";
          py = "python";
        };
      };

      programs.mise = {
        enable = lib.mkDefault true;

        globalConfig.tools.python = "latest";
      };
    };
}
