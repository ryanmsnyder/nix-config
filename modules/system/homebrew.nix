{ ... }:

{
  # Homebrew package management configuration
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall"; # Uninstall packages/casks not in Brewfile (less aggressive than "zap")
      upgrade = false;
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
    };
  };
}
