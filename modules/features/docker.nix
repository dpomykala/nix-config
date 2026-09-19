{ self, ... }: {
  flake.modules.darwin.docker-desktop = {
    homebrew.casks = [ "docker-desktop" ];
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home.packages = with pkgs; [ lazydocker ];
  };
}
