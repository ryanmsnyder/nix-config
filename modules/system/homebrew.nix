{ ... }:

{
  # Homebrew package management configuration
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
      "blueutil"
    ];

    casks = [
      "claude"
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
      "bitwarden" = 1352778147;  # now its in nixpkgs but it doesn't have the safari extension packaged with it
      "amphetamine" = 937984704;
      "adguard-for-safari" = 1440147259;
    };
  };
}
