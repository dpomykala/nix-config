/*
  Python through uv: the Python versions and the Python tools. ty checks types,
  and Ruff lints and formats.

  uv installs the tools from PyPI instead of nixpkgs, because Ruff and ty
  release often and django-template-lsp isn't in nixpkgs. Home Manager upgrades
  the tools on every activation.
*/
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
          # Django template language server, run as djlsp
          "django-template-lsp"
          "pre-commit"
          "ruff"
          "ty"
        ];

        prune = true;
      };
    };
  };
}
