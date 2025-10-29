{self, ...}: {
  security.pam.services.sudo_local = {
    enable = true;

    # Enable sudo authentication with Touch ID / Apple Watch
    touchIdAuth = true;
    watchIdAuth = true;
  };

  system = {
    # The version used for backwards compatibility
    stateVersion = 5;

    # The Git commit hash for darwin-version
    configurationRevision = self.rev or self.dirtyRev or null;

    # Scripts executed when booting or rebuilding the system
    activationScripts.postActivation.text = ''
      # Reload the system settings to avoid the need for a reboot
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      dock = {
        # Automatically hide and show the Dock
        autohide = true;

        # Enable the magnification of the icons in the Dock on hover
        magnification = true;

        # Set the size of the magnified icons in the Dock (16 - 128)
        largesize = 95;

        # persistent-apps = [];

        # persistent-others = [];

        # Set the size of the icons in the Dock (16 - 128)
        tilesize = 35;

        # Disable the Quick Note hot corner action for the bottom right corner
        wvous-br-corner = 1;

        # Set the hot corner action for the top right corner (4 - Desktop)
        wvous-tr-corner = 4;
      };

      finder = {
        # Use the current folder when searching in Finder
        FXDefaultSearchScope = "SCcf";

        # Do not show a warning when changing a file extension in Finder
        FXEnableExtensionChangeWarning = false;

        # Use the Column View as the default view in Finder
        FXPreferredViewStyle = "clmv";

        # Set Home as the default folder for a new Finder window
        NewWindowTarget = "Home";

        # Show path breadcrumbs in Finder
        ShowPathbar = true;

        # Show the status bar in Finder
        ShowStatusBar = true;

        # Show the full POSIX path in the Finder window title
        _FXShowPosixPathInTitle = true;

        # Keep folders on top when sorting by name in Finder
        _FXSortFoldersFirst = true;
      };

      trackpad = {
        # Set the force required for a normal click (0, 1, 2)
        # The lower the value, the lighter the click
        FirstClickThreshold = 0;

        # Set the force required for a Force click (0, 1, 2)
        # The lower the value, the lighter the click
        SecondClickThreshold = 0;
      };

      # Settings for Apple Global Domain
      NSGlobalDomain = {
        # Enable full keyboard navigation using Tab and Shift-Tab (0, 2, 3)
        AppleKeyboardUIMode = 3;

        # Disable the press-and-hold accents menu
        ApplePressAndHoldEnabled = false;

        # Always show file extensions in Finder
        # The finder.AppleShowAllExtensions option does not work, use this instead
        AppleShowAllExtensions = true;

        # Set how fast a key starts repeating when pressed and held (15 - 120)
        # The lower the value, the faster it starts repeating
        InitialKeyRepeat = 15;

        # Set how fast a key repeats when pressed and held (2 - 120)
        # The lower the value, the faster the key repeat (set to 120 to disable)
        KeyRepeat = 2;

        # Use F-keys as standard function keys
        # Use Fn + F-keys for system functions
        "com.apple.keyboard.fnState" = true;

        # Set the trackpad tracking speed (0 - 3)
        "com.apple.trackpad.scaling" = 3.0;

        # Enable a feedback sound when changing the system volume
        "com.apple.sound.beep.feedback" = 1;
      };

      CustomUserPreferences = {
        # -> Mission Control / App Exposé gestures
        "com.apple.dock" = {
          # Enable the Mission Control gesture on the trackpad
          # See: TrackpadThreeFingerVertSwipeGesture / TrackpadFourFingerVertSwipeGesture
          showMissionControlGestureEnabled = true;

          # Enable the App Exposé gesture on the trackpad
          # See: TrackpadThreeFingerVertSwipeGesture / TrackpadFourFingerVertSwipeGesture
          showAppExposeGestureEnabled = true;
        };
        "com.apple.AppleMultitouchTrackpad" = {
          # Use a 3- or 4-finger vertical swipe for Mission Control (up)
          # and App Exposé (down)
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
        };
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
          # Use a 3- or 4-finger vertical swipe for Mission Control (up)
          # and App Exposé (down) in an external trackpad
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
        };
        # The .GlobalPreferences plist file is used for Apple Global Domain
        # The domains located in the ByHost subdirectory require the full path
        "~/Library/Preferences/ByHost/.GlobalPreferences" = {
          # Required for Mission Control / App Exposé gesture setting values
          # to display correctly in the System Settings GUI app as a 3-finger
          # vertical swipe (up / down)
          "com.apple.trackpad.threeFingerVertSwipeGesture" = 2;
          "com.apple.trackpad.fourFingerVertSwipeGesture" = 2;
        };
        # <- Mission Control / App Exposé gestures

        "com.apple.finder" = {
          # Do not show a warning when deleting from iCloud Drive
          FXEnableRemoveFromICloudDriveWarning = false;

          # Delete items from the Trash that are older than 30 days
          FXRemoveOldTrashItems = true;

          # Do not show a warning when emptying the Trash
          WarnOnEmptyTrash = false;

          # Keep folders on top on the Desktop
          _FXSortFoldersFirstOnDesktop = true;
        };

        # The domains located in the ByHost subdirectory require the full path
        "~/Library/Preferences/ByHost/com.apple.controlcenter" = {
          # Show the battery percentage in the menu bar
          BatteryShowPercentage = true;
        };
      };
    };

    # Enable keyboard mappings
    keyboard.enableKeyMapping = true;

    # Remap the Caps Lock key to Escape
    keyboard.remapCapsLockToEscape = true;
  };
}
