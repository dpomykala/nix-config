_: {
  flake.modules.homeManager.python = { lib, ... }: {
    home = {
      # uv installs the default Python and the tools here
      sessionPath = [ "$HOME/.local/bin" ];

      shellAliases = {
        cl-pyc = "find ./ -name '*.pyc' -delete";
        py = "python";
      };
    };

    programs.uv = {
      enable = lib.mkDefault true;

      python = {
        default = "3.15";

        prune = true;

        versions = [
          "3.12"
          "3.13"
          "3.14"
          "3.15"
        ];
      };

      tool = {
        packages = [
          "black"
          "pre-commit"
          "ruff"
          "ty"
        ];

        prune = true;
      };
    };
  };
}
