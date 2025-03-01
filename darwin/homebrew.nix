{config, ...}: {
  homebrew = {
    enable = true;

    # Specify the same taps as those managed by nix-homebrew
    # This prevents nix-darwin from trying to untap all taps
    # See: https://github.com/zhaofengli/nix-homebrew/issues/5
    taps = builtins.attrNames config.nix-homebrew.taps;

    casks = [
      # GUI applications
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
      "wezterm"

      # Nerd Fonts used by the WezTerm, Starship etc.
      # Homebrew by default installs fonts per-user in ~/Library/Fonts
      # TODO: Install system-wide using nix-darwin's fonts.packages?
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
    ];

    # Applications from the Mac App Store (login required)
    # Applications installed in this way must be uninstalled manually
    # This option automatically installs the mas CLI tool (brew)
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
    # DOES NOT work for applications installed via masApps
    onActivation.cleanup = "zap";
  };
}
