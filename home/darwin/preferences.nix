{lib, ...}: {
  # Reload the settings to avoid the need for a re-login
  home.activation.activateSettings = lib.hm.dag.entryAfter ["installPackages"] ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  targets.darwin = {
    currentHostDefaults = {
      # Show the battery percentage in the menu bar
      "com.apple.controlcenter".BatteryShowPercentage = true;
    };

    defaults = {
      "com.apple.Safari" = {
        # FIXME: Does not work?
        # Disable autofill of credit card numbers (use 1Password)
        AutoFillCreditCardData = false;

        # FIXME: Does not work?
        # Disable autofill of usernames and passwords (use 1Password)
        AutoFillPasswords = false;

        # FIXME: Does not work?
        # Show the "Develop" menu in the menu bar
        IncludeDevelopMenu = true;

        # FIXME: Does not work?
        # Show the status bar
        ShowOverlayStatusBar = true;
      };

      # Disable use of .DS_Store files on thumb drives
      "com.apple.desktopservices".DSDontWriteUSBStores = true;

      "com.apple.dock" = {
        # Automatically hide and show the Dock
        autohide = true;

        # Set the size of the icons in the Dock (16 - 128)
        tilesize = 35;
      };

      "com.apple.finder" = {
        # Delete items from the Trash after 30 days
        FXRemoveOldTrashItems = true;

        # Show the path bar (breadcrumbs) at the bottom of a Finder window
        ShowPathBar = true;

        # Show the status bar at the bottom of a Finder window
        ShowStatusBar = true;
      };

      NSGlobalDomain = {
        # Disable the press-and-hold accents menu
        ApplePressAndHoldEnabled = false;

        # Always show file extensions in Finder
        AppleShowAllExtensions = true;

        # Set how fast a key repeats when pressed and held (2 - 120)
        # The lower the value, the faster the key repeat (set to 120 to disable)
        KeyRepeat = 2;
      };
    };

    # FIXME: Does not work (e.g. in Safari)?
    # Set the default search engine
    search = "DuckDuckGo";
  };
}
