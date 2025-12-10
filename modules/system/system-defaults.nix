{ user, ... }:

{
  # macOS system defaults and preferences
  system.defaults = {
    # Mouse tracking speed
    ".GlobalPreferences"."com.apple.mouse.scaling" = 9.0;

    NSGlobalDomain = {
      # Enable Dark mode
      AppleInterfaceStyle = "Dark";

      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;

      # If you press and hold certain keyboard keys when in a text area, the key's character begins to repeat.
      # This is very useful for vim users, they use `hjkl` to move cursor.
      # sets how long it takes before it starts repeating.
      InitialKeyRepeat = 13; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
      # sets how fast it repeats once it starts.
      KeyRepeat = 2; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

      # Mouse and sound settings
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;

      # Trackpad 
      "com.apple.trackpad.scaling" = 3.0; # trackpad speed - currently have to log out and back in for change to take effect
      # "com.apple.trackpad.enableSecondaryClick" = true;

      # Disable automatic capitalization and spelling correction
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    trackpad = {
      # Clicking = true; # enable trackpad tap to click
      # TrackpadRightClick = true; # enable trackpad right click
      # TrackpadThreeFingerDrag = true;
      # ActuationStrength = 0; # silent click
    };

    magicmouse = {
      # Enable secondary click on magic mouse when clicking the right side
      MouseButtonMode = "TwoButton";
    };

    finder = {
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = true;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Disable animation when switching screens or opening apps
    # universalaccess.reduceMotion = true;

    # manages Apple plist settings in ~/Library/Preferences
    CustomUserPreferences = {
      # Raycast settings. Launch Raycast with CMD-SPC
      "com.raycast.macos" = {
        NSNavLastRootDirectory = "~/src/scripts/raycast";
        "NSStatusItem Visible raycastIcon" = 0;
        commandsPreferencesExpandedItemIds = [
          "extension_noteplan-3__00cda425-a991-4e4e-8031-e5973b8b24f6"
          "builtin_package_navigation"
          "builtin_package_scriptCommands"
          "builtin_package_floatingNotes"
        ];
        "emojiPicker_skinTone" = "mediumLight";
        initialSpotlightHotkey = "Command-49";  
        navigationCommandStyleIdentifierKey = "legacy";
        onboardingCompleted = true;
        "onboarding_canShowActionPanelHint" = 0;
        "onboarding_canShowBackNavigationHint" = 0;
        "onboarding_completedTaskIdentifiers" = [
          "startWalkthrough"
          "calendar"
          "setHotkeyAndAlias"
          "snippets"
          "quicklinks"
          "installFirstExtension"
          "floatingNotes"
          "windowManagement"
          "calculator"
          "raycastShortcuts"
          "openActionPanel"
        ];
        organizationsPreferencesTabVisited = 1;
        popToRootTimeout = 60;
        raycastAPIOptions = 8;
        raycastGlobalHotkey = "Command-49"; # launch Raycast with command-space
        raycastPreferredWindowMode = "default";
        raycastShouldFollowSystemAppearance = 1;
        raycastWindowPresentationMode = 1;
        showGettingStartedLink = 0;
        "store_termsAccepted" = 1;
        suggestedPreferredGoogleBrowser = 1;
        "permissions.folders.read:/Users/${user}/Desktop" = 1;
        "permissions.folders.read:/Users/${user}/Documents" = 1;
        "permissions.folders.read:/Users/${user}/Downloads" = 1;
        "permissions.folders.read:cloudStorage" = 1;
      };

      "com.binarynights.ForkLift" = {
        TerminalApplication = 0;
        alwaysShowTabbar = 1;
        applicationDeleter = 0;
        cloudSync = 0;
        # connectViewProtocol = "smb";
        connectViewShowAdvanced = 1;
        hidePathBar = 0;
        hideTitleBar = 0;
        infoMode = 0;
        # Sticks but does seems to reset the appearance to non-alternating?
        listViewAlternatingBackground = 1;
        pdfAutoScales = 0;
        pdfDisplayMode = 0;
        pdfScaleFactor = 1;
        previewDividerPosition = 300;
        recursiveSearch = 0;
        remoteSearchMode = 0;
        searchMode = 0;
        showDeviceInfo = 1;
        "NSToolbar Configuration com.apple.NSColorPanel" = {
            "TB Is Shown" = 1;
        };
        "NSToolbar Configuration Toolbar" = {
            "TB Display Mode" = 2;
            "TB Icon Size Mode" = 1;
            "TB Is Shown" = 1;
            "TB Item Identifiers" = [
                "backForward"
                "NSToolbarFlexibleSpaceItem"
                "groupBy"
                "toggleHiddenFiles"
                "NSToolbarSpaceItem"
                "favorites"
                "actions"
                "NSToolbarSpaceItem"
                "sync"
                "teminal"
                "compare"
                "scm"
                "NSToolbarSpaceItem"
                "activities"
                "NSToolbarSpaceItem"
                "search"
            ];
            "TB Size Mode" = 1;
        };
      };

      "com.apple.finder" = {
        _FXSortFoldersFirst = true;
        FXICloudDriveEnabled = true;
        FXICloudDriveDesktop = true;
        FXICloudDriveDocuments = true;
        FXDefaultSearchScope = "SCcf"; # Search current folder by default
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
      };

      "com.apple.Safari" = {
        # Privacy: don't send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = false;
        # Press Tab to highlight each item on a web page
        WebKitTabToLinksPreferenceKey = true;
        ShowFullURLInSmartSearchField = true;
        # Prevent Safari from opening 'safe' files automatically after downloading
        AutoOpenSafeDownloads = false;
        ShowFavoritesBar = true;
        ShowFavoritesBar-v2 = true; 
        IncludeInternalDebugMenu = false;
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        WebContinuousSpellCheckingEnabled = true;
        WebAutomaticSpellingCorrectionEnabled = false;
        AutoFillFromAddressBook = true;
        AutoFillCreditCardData = true;
        AutoFillMiscellaneousForms = true;
        WarnAboutFraudulentWebsites = true;
        WebKitJavaEnabled = false;
        WebKitJavaScriptCanOpenWindowsAutomatically = false;
        "PreferencesModulesMinimumWidths.MinimumWidths.DeveloperMenuVisibility" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
      };

      "com.apple.screensaver" = {
        # Don't require password until 10 minutes after sleep or screen saver begins
        askForPassword = 0;
        askForPasswordDelay = 600;
      };

      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;

      "com.apple.AdLib" = { allowApplePersonalizedAdvertising = false; };
    };
  };
}
