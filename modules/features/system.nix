/*
  Home Manager sets the macOS user preferences, because a home activates
  without sudo and only Home Manager writes the ByHost keys. nix-darwin sets
  only the settings that need root or aren't user preferences. See
  docs/architecture.md §4.
*/
{ self, ... }:
{
  flake.modules.darwin.system = {
    security.pam.services.sudo_local = {
      # Make Touch ID work in multiplexers that run panes in the background
      # session, such as Herdr and tmux
      reattach = true;

      # Enable sudo authentication with Touch ID / Apple Watch
      touchIdAuth = true;
      watchIdAuth = true;
    };

    system = {
      # The Git commit hash for darwin-version
      configurationRevision = self.rev or self.dirtyRev or null;

      keyboard = {
        # Enable keyboard mappings
        enableKeyMapping = true;

        # Remap the Caps Lock key to Escape
        remapCapsLockToEscape = true;
      };

      # The version used for backwards compatibility
      stateVersion = 6;
    };
  };

  flake.modules.homeManager.system =
    { config, lib, ... }:
    let
      # Values of the horizontal trackpad swipe gesture keys. The trackpad uses
      # the keys in the trackpad domains, but System Settings shows the ByHost
      # copy, so both need the same values.
      horizontalSwipe = {
        betweenPages = 1;
        betweenSpaces = 2;
      };

      # Written to the domains of both the built-in and Bluetooth trackpads
      trackpad = {
        # Set the force required for a normal click (0, 1, 2)
        # The lower the value, the lighter the click
        FirstClickThreshold = 0;

        # Set the force required for a Force click (0, 1, 2)
        # The lower the value, the lighter the click
        SecondClickThreshold = 0;

        # Swipe between pages with 3 fingers, and between desktops and
        # full-screen apps with 4 fingers
        TrackpadFourFingerHorizSwipeGesture = horizontalSwipe.betweenSpaces;
        TrackpadThreeFingerHorizSwipeGesture = horizontalSwipe.betweenPages;
      };
    in
    {
      home = {
        activation.activateSettings = lib.hm.dag.entryAfter [ "setDarwinDefaults" ] ''
          # Reload the settings to avoid the need for a re-login
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

          # Restart the Dock to apply its settings, because activateSettings
          # doesn't reload it
          /usr/bin/killall -qu "$USER" Dock || true
        '';

        # Hide the "Last login" message that login(1) prints in new terminals
        file.".hushlogin".text = "";
      };

      targets.darwin = {
        currentHostDefaults = {
          # Show the battery percentage in the menu bar
          "com.apple.controlcenter".BatteryShowPercentage = true;

          # Mirror the trackpad gestures for System Settings
          NSGlobalDomain = {
            "com.apple.trackpad.fourFingerHorizSwipeGesture" = horizontalSwipe.betweenSpaces;
            "com.apple.trackpad.threeFingerHorizSwipeGesture" = horizontalSwipe.betweenPages;
          };
        };

        defaults = {
          "com.apple.AppleMultitouchTrackpad" = trackpad;

          # Safari reads these at launch, so quit it before activation. The
          # terminal needs Full Disk Access to write to Safari's container.
          "com.apple.Safari" = {
            # Disable autofill of credit card numbers (use 1Password)
            AutoFillCreditCardData = false;

            # Show the "Develop" menu in the menu bar
            IncludeDevelopMenu = true;

            # Safari ignores the search engine keys that the `search` option
            # writes, and reads only this one
            SearchProviderShortName = config.targets.darwin.search;

            # Show the full website address in the address bar
            ShowFullURLInSmartSearchField = true;

            # Show the status bar
            ShowOverlayStatusBar = true;
          };

          # Disable use of .DS_Store files on USB drives
          "com.apple.desktopservices".DSDontWriteUSBStores = true;

          "com.apple.dock" = {
            # Automatically hide and show the Dock
            autohide = true;

            # Set the size of the magnified icons in the Dock (16 - 128)
            largesize = 95;

            # Enable the magnification of the icons in the Dock on hover
            magnification = true;

            # No apps in the Dock
            persistent-apps = [ ];

            # Enable App Exposé with a 3-finger swipe down
            showAppExposeGestureEnabled = true;

            # Set the size of the icons in the Dock (16 - 128)
            tilesize = 35;

            # Disable the Quick Note hot corner action for the bottom right
            # corner
            wvous-br-corner = 1;

            # Set the hot corner action for the top right corner (4 - Desktop)
            wvous-tr-corner = 4;
          };

          "com.apple.driver.AppleBluetoothMultitouch.trackpad" = trackpad;

          "com.apple.finder" = {
            # Use the current folder when searching in Finder
            FXDefaultSearchScope = "SCcf";

            # Do not show a warning when changing a file extension in Finder
            FXEnableExtensionChangeWarning = false;

            # Do not show a warning when deleting from iCloud Drive
            FXEnableRemoveFromICloudDriveWarning = false;

            # Use the Column View as the default view in Finder
            FXPreferredViewStyle = "clmv";

            # Delete items from the Trash after 30 days
            FXRemoveOldTrashItems = true;

            # Set Home as the default folder for a new Finder window
            NewWindowTarget = "PfHm";

            # Show the path bar (breadcrumbs) at the bottom of a Finder window.
            # Finder ignores the `ShowPathBar` key of the typed HM option.
            ShowPathbar = true;

            # Show the status bar at the bottom of a Finder window
            ShowStatusBar = true;

            # Do not show a warning when emptying the Trash
            WarnOnEmptyTrash = false;

            # Show the full POSIX path in the Finder window title
            _FXShowPosixPathInTitle = true;

            # Keep folders on top when sorting by name in Finder
            _FXSortFoldersFirst = true;

            # Keep folders on top on the Desktop
            _FXSortFoldersFirstOnDesktop = true;
          };

          NSGlobalDomain = {
            # Disable the 2-finger swipe between pages on the trackpad, which
            # uses 3 fingers instead
            AppleEnableSwipeNavigateWithScrolls = false;

            # Enable full keyboard navigation using Tab and Shift-Tab (macOS 14
            # and later use 2, older versions use 3)
            AppleKeyboardUIMode = 2;

            # Disable the press-and-hold accents menu
            ApplePressAndHoldEnabled = false;

            # Always show file extensions in Finder
            AppleShowAllExtensions = true;

            # Set how fast a key starts repeating when pressed and held
            # (15 - 120). The lower the value, the faster it starts repeating.
            InitialKeyRepeat = 15;

            # Set how fast a key repeats when pressed and held (2 - 120)
            # The lower the value, the faster the key repeat
            KeyRepeat = 2;

            # Use F-keys as standard function keys
            # Use Fn + F-keys for system functions
            "com.apple.keyboard.fnState" = true;

            # Enable a feedback sound when changing the system volume
            "com.apple.sound.beep.feedback" = 1;

            # Set the trackpad tracking speed (0 - 3)
            "com.apple.trackpad.scaling" = 3.0;
          };
        };

        # Set the search engine for "Search With" in context menus and, through
        # SearchProviderShortName, for Safari
        search = "DuckDuckGo";
      };
    };
}
