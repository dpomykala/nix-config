{
  config,
  self,
  ...
}: {
  # NOTE: nix-homebrew options are provided by the flake input
  nix-homebrew = let
    inherit (self.inputs) homebrew-bundle homebrew-cask homebrew-core;
  in {
    # Install Homebrew under the default prefix
    enable = true;

    # Enable fully-declarative tap management
    # Only taps declared in this configuration are allowed
    mutableTaps = false;

    # Use declarative tap management
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-core" = homebrew-core;
    };
  };

  homebrew = {
    enable = true;

    casks = [
      "1password"
      #"adobe-acrobat-reader"
      #"arc"
      #"brave-browser"
      "docker"
      #"firefox"
      #"google-chrome"
      "jetbrains-toolbox"
      "karabiner-elements"
      "logi-options+"
      #"notion"
      #"nvidia-geforce-now"
      "obsidian"
      "raycast"
      "slack"
      "spotify"
      #"the-unarchiver"
      #"tunnelblick"
      "visual-studio-code"
      #"vlc"
    ];

    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: mas search "1Password"
    masApps = {
      "1Password for Safari" = 1569813296;
      Amphetamine = 937984704;
      Bear = 1091189122;
      Numbers = 409203825;
      Pages = 409201541;
      Things = 904280696;
    };

    # Remove all formulae not listed in this configuration
    # WARN: DOES NOT work for applications installed via masApps
    onActivation.cleanup = "zap";

    # Specify the same taps as those managed by nix-homebrew
    # This prevents nix-darwin from trying to untap all taps
    # See: https://github.com/zhaofengli/nix-homebrew/issues/5
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
