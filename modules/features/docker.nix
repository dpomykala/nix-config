_: {
  flake.modules.darwin.docker = {
    homebrew.casks = [ "docker-desktop" ];
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home = {
      packages = with pkgs; [ lazydocker ];

      shellAliases = {
        cl-docker = "docker system prune --volumes -f";
        dps = "docker ps";
        dcp = "docker-compose";
      };
    };
  };
}
