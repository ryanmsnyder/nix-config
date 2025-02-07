{ config, pkgs, lib, home-manager, user, ... }:

let
#   sharedFiles = import ../shared/files.nix { inherit config pkgs; };
#   additionalFiles = import ./files.nix { inherit user config pkgs; };

  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  darwinScripts = builtins.attrValues scripts;


in

{
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstall packages/casks not in Brewfile
      upgrade = true;
    };


    global = {
      brewfile = true;
      lockfiles = true;
      autoUpdate = false;
    };

    # taps = [
    #   "haimgel/display_switch"
    #   "waydabber/betterdisplay"
    # ];

    brews = [
      "rom-tools" # supplies chdman (convert files to .chd for retro gaming)
      # "display_switch"
      # "waydabber/betterdisplay/betterdisplaycli"
    ];

    casks = [
      "chatgpt"
      "calibre"
      "discord"
      "betterdisplay"
      "microsoft-excel"
    ];

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # These apps won't be automatically uninstalled if removed
    masApps = {
      "magnet" = 441258766;
      "bitwarden" = 1352778147;  # currently not in nixpkgs for darwin so install via mas
      "amphetamine" = 937984704;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        # Packages/apps that will only be exposed to the user via ~/.nix-profile
        # packages = pkgs.callPackage ./packages.nix {};
        packages = pkgs.callPackage ./packages.nix {} ++ darwinScripts;
        # file = lib.mkMerge [
        #   sharedFiles
        #   additionalFiles
        # ];
        file.".config/karabiner/karabiner.json".source = ../../shared/home-manager/config/karabiner/karabiner.json;

        stateVersion = "23.11";
      };

        # Import home-manager programs shared between MacOS and nixOS
        imports = [
          ../../shared/home-manager
        ];


      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  system.defaults = {
    # Mouse tracking speed
    ".GlobalPreferences"."com.apple.mouse.scaling" = 9.0;

    NSGlobalDomain = {
      # Enable Dark mode
      AppleInterfaceStyle = "Dark";

      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;

      # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
      # This is very useful for vim users, they use `hjkl` to move cursor.
      # sets how long it takes before it starts repeating.
      InitialKeyRepeat = 13; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
      # sets how fast it repeats once it starts.
      KeyRepeat = 2; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

      # Mouse and sound settings
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;

      # Trackpad speed
      "com.apple.trackpad.scaling" = 3.0; # currently have to log out and back in for change to take effect

      # Disable automatic capitalization and spelling correction
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      
    };

    dock = {
      autohide = true;  # hide dock
      autohide-delay = 0.00;  # delay before dock shows
      autohide-time-modifier = 0.50;  # speed of dock animation when showing/hiding
      show-recents = false;
      launchanim = true;
      orientation = "bottom";
      tilesize = 48;
      wvous-bl-corner = 4; # hot corner that shows desktop when hovering mouse over bottom left corner
      mouse-over-hilite-stack = true; # highlight effect that follows the mouse in a Dock stack
      persistent-apps = [ # configure Dock apps
        "${pkgs.forklift}/Applications/ForkLift.app"
        "${pkgs.wezterm}/Applications/WezTerm.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "${pkgs.spotify}/Applications/Spotify.app"
        "/System/Applications/Reminders.app"
        "/System/Applications/Calendar.app"
      ];
      # persistent-others = [ "/Users/${user}/Downloads" ];
    };

    finder = {
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true; # enable trackpad tap to click
      TrackpadRightClick = true; # enable trackpad right click
      TrackpadThreeFingerDrag = true;
    };

    magicmouse = {
      # Enable secondary click on magic mouse when clicking the right side
      MouseButtonMode = "TwoButton";
    };

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
        # Privacy: don’t send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = false;
        # Press Tab to highlight each item on a web page
        WebKitTabToLinksPreferenceKey = true;
        ShowFullURLInSmartSearchField = true;
        # Prevent Safari from opening ‘safe’ files automatically after downloading
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

  launchd.user.agents.raycast.serviceConfig = {
    Disabled = false;
    ProgramArguments = [ "/Applications/Raycast.app/Contents/Library/LoginItems/RaycastLauncher.app/Contents/MacOS/RaycastLauncher" ];
    RunAtLoad = true;
  };

  # disable Spotlight's CMD-SPC hotkey so Raycast can use it (no restart needed for this to work)
  # add Downloads stack to Dock with grid view (there's a native system.defaults.dock.persistent-others option that allows
  # for setting paths but it doesn't seem to allow for setting the "displayas" parameter)
  system.activationScripts.preUserActivation.text = ''
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
    <dict>
      <key>enabled</key><false/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>1048576</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.dock persistent-others -array "
    <dict>
      <key>tile-data</key>
      <dict>
        <key>arrangement</key>
        <integer>1</integer>
        <key>displayas</key>
        <integer>1</integer>
        <key>file-data</key>
        <dict>
          <key>_CFURLString</key>
          <string>file:///Users/${user}/Downloads</string>
          <key>_CFURLStringType</key>
          <integer>15</integer>
        </dict>
        <key>file-type</key>
        <integer>2</integer>
        <key>showas</key>
        <integer>2</integer>
      </dict>
      <key>tile-type</key>
      <string>directory-tile</string>
    </dict>
    "
    
  '';

  system.activationScripts.postActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    killall Dock
  '';

}
