{ config, ... }: {
  homebrew = {
    enable = true;

    # Specify the same taps as those managed by nix-homebrew
    # This prevents nix-darwin from trying to untap all taps
    # See: https://github.com/zhaofengli/nix-homebrew/issues/5
    taps = builtins.attrNames config.nix-homebrew.taps;

    casks = [
      # GUI applications
      "1password"
      "docker"
      "jetbrains-toolbox"
      "karabiner-elements"
      "logi-options+"
      "obsidian"
      "raycast"
      "slack"
      "spotify"
      "visual-studio-code"
      "wezterm"
      #"adobe-acrobat-reader"
      #"arc"
      #"brave-browser"
      #"firefox"
      #"google-chrome"
      #"notion"
      #"nvidia-geforce-now"
      #"the-unarchiver"
      #"tunnelblick"
      #"vlc"

      # Nerd Fonts used by the WezTerm, Starship etc.
      # Homebrew by default installs fonts per-user in ~/Library/Fonts
      # TODO: Install system-wide using nix-darwin's fonts.packages?
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
    ];

    # Applications from Mac App Store
    # This option automatically installs the `mas` CLI tool (brew)
    # Applications installed in this way must be uninstalled manually
    # To search for an application ID: mas search "1Password"
    #masApps = {
    #  "1Password for Safari" = 1569813296;
    #  Amphetamine = 937984704;
    #  Bear = 1091189122;
    #  Things = 904280696;
    #};

    # Remove all formulae not listed in this configuration
    # DOES NOT work for applications installed via masApps
    onActivation.cleanup = "zap";
  };
}
