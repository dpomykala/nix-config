# Home Manager profile for all Linux distributions (including NixOS).
{ self, ... }: {
  flake.modules.homeManager.home-linux = { config, ... }: {
    imports = with self.modules.homeManager; [
      # Profiles
      base

      # Features
      dconf
    ];

    home.homeDirectory = "/home/${config.home.username}";
  };
}
