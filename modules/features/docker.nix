{ self, ... }: {
  flake.modules.darwin.docker-desktop = {
    imports = [ self.modules.darwin.homebrew ];

    homebrew.casks = [ "docker-desktop" ];
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home.packages = with pkgs; [ lazydocker ];
  };
}
