# Home Manager profile for all generic Linux distributions (non-NixOS).
{ self, ... }: {
  flake.modules.homeManager.home-linux-generic = {
    imports = with self.modules.homeManager; [
      # Profiles
      home-linux
    ];

    # Enable better support for non-NixOS Linux distributions. This also
    # enables `targets.genericLinux.gpu`, which needs a one-time `sudo` setup
    # that the activation prints.
    targets.genericLinux.enable = true;
  };
}
