{ config, pkgs, lib, home-manager, ... }:

let
  user = "ryan";
  # Define the content of your file as a derivation
#   sharedFiles = import ../shared/files.nix { inherit config pkgs; };
#   additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # imports = [
  #   ./dock
  # ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    # casks = pkgs.callPackage ./casks.nix {};

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      "magnet" = 441258766;
      "bitwarden" = 1352778147;  # currently not in nixpkgs for darwin so install via mas
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

  # Fully declarative dock using the latest from Nix Store
  # local.dock.enable = true;
  # local.dock.entries = [
  #   # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Obsidian.app"; }
  #   { path = "${config.users.users.${user}.home}/Applications/Home Manager Apps/Obsidian.app"; }
  #   # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Bruno.app"; }
  #   # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Visual\ Studio\ Code.app"; }
  #   # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/WezTerm.app"; }
  #   { path = "${config.users.users.${user}.home}/Applications/Home Manager Apps/WezTerm.app"; }
  #   # { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }  # hard code Safari path since it ships with MacOS

  #   {
  #     path = "${config.users.users.${user}.home}/Downloads";
  #     section = "others";
  #     options = "--sort name --view grid --display folder";
  #   }
  # ];

  # local = {
  #   dock.enable = true;
  #   dock.entries = [
  #     # { path = "/Applications/Slack.app/"; }
  #     # { path = "/System/Applications/Messages.app/"; }
  #     # { path = "/System/Applications/Facetime.app/"; }
  #     # { path = "/Applications/Telegram.app/"; }
  #     { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
  #     # { path = "/System/Applications/Music.app/"; }
  #     # { path = "/System/Applications/News.app/"; }
  #     # { path = "/System/Applications/Photos.app/"; }
  #     # { path = "/System/Applications/Photo Booth.app/"; }
  #     # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Bruno.app"; }
  #     { path = "${pkgs.obsidian}/Applications/Obsidian.app/"; }
  #     { path = "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"; }
  #     { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
  #     { path = "/System/Applications/Reminders.app/"; }
  #     # { path = "/Applications/TablePlus.app/"; }
  #     # { path = "/Applications/Drafts.app/"; }
  #     # { path = "/System/Applications/Home.app/"; }
  #     {
  #       path = "${config.users.users.${user}.home}/Downloads";
  #       section = "others";
  #       options = "--sort name --view grid --display folder";
  #     }
  #   ];
  # };

}
