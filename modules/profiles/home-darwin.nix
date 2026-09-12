# Home Manager profile for Darwin.
{ self, ... }: {
  flake.modules.homeManager.home-darwin = { config, ... }: {
    imports = with self.modules.homeManager; [
      # Profiles
      base

      # Features
      system
    ];

    home.homeDirectory = "/Users/${config.home.username}";
  };
}
