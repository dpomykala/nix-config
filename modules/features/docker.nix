_: {
  flake.modules.darwin.docker = {
    homebrew.casks = [ "docker-desktop" ];
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        # Docker's official server, for BuildKit checks and Compose files
        docker-language-server
        # Completion and hover for Dockerfile instructions
        dockerfile-language-server
        lazydocker
      ];

      shellAliases = {
        cl-docker = "docker system prune --volumes -f";
        dps = "docker ps";
        dcp = "docker compose";
      };
    };
  };
}
