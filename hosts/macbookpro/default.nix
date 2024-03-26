{ config, pkgs, ... }:

let 
  # set name of home folder
  user = "ryan"; 

  # Import custom Darwin
  customDarwinPackagesPath = ../../custom-packages/macos;
  plexDarwin = pkgs.callPackage (customDarwinPackagesPath + "/plex.nix") {};

  # packages that should only be installed on specific host/machine
  hostSpecificPackages = with pkgs; [ qbittorrent plexDarwin ];
in

{

  # set custom config option that's defined in modules/shared/default.nix so username can be accessed
  # in other modules
  users.myUser = user;

  imports = [
    ../../modules/darwin/home-manager
    ../../modules/shared
    ../../modules/shared/cachix
    ../../modules/darwin/system-config.nix
    ../../modules/darwin/home-manager/dockutil.nix
  ];

  # install packages via home-manager that are specific to this host/machine
  # these will be installed in addition to other packages defined in modules/darwin/home-manager/default.nix
  home-manager.users.${user}.home.packages = hostSpecificPackages;

  # Configure applications that should appear in Dock
  local = {
    dock.enable = true;
    dock.entries = [
      { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
      { path = "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"; }
      { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Bruno.app"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app/"; }
      { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
      { path = "/System/Applications/Reminders.app/"; }
      # { path = "/Applications/TablePlus.app/"; }
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
    ];
  };


}
