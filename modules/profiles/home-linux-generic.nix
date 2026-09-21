# Home Manager profile for all generic Linux distributions (non-NixOS).
{ self, ... }: {
  flake.modules.homeManager.home-linux-generic = {
    imports = with self.modules.homeManager; [
      # Profiles
      home-linux

      # Features
      nixgl
    ];

    # Enable better support for non-NixOS Linux distributions
    targets.genericLinux.enable = true;
  };
}
