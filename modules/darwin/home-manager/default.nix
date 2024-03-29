{ config, pkgs, lib, home-manager, user, ... }:

let
  # Define the content of your file as a derivation
#   sharedFiles = import ../shared/files.nix { inherit config pkgs; };
#   additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
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
      "numbers" = 409203825;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        # Packages/apps that will only be exposed to the user via ~/.nix-profile
        packages = pkgs.callPackage ./packages.nix {};
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
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;

      # Key repeat settings
      KeyRepeat = 2;
      InitialKeyRepeat = 15;

      # Mouse and sound settings
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;
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
    };

    finder = {
      _FXShowPosixPathInTitle = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
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
      };

     "com.apple.screensaver" = {
        # Don't require password until 10 minutes after sleep or screen saver begins
        askForPassword = 0;
        askForPasswordDelay = 600;
      };
    };
  };

  # remap Spotlight to CTRL-SPC so Raycast can use CMD-SPC (no restart needed for this to work)
  # only applies to current user
  system.activationScripts.postActivation.text = ''
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
    <dict>
      <key>enabled</key><true/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>262144</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "
    <dict>
      <key>enabled</key><false/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>262144</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 61 "
    <dict>
      <key>enabled</key><true/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>1572864</integer>
        </array>
      </dict>
    </dict>
    "

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';


}
