{ config, pkgs, user, ... }:

{
  imports = [
    ./home-manager
    ../../modules/darwin/home-manager
    ../../modules/shared
    ../../modules/shared/cachix
    ../../modules/darwin/system-config.nix
  ];

  # # Configure applications that should appear in Dock
  # local = {
  #   dock.enable = true;
  #   dock.entries = [
  #     { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }
  #     { path = "/System/Applications/Calendar.app"; }
  #     { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
  #     { path = "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"; }
  #     { path = "${pkgs.obsidian}/Applications/Obsidian.app/"; }
  #     { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
  #     { path = "/System/Applications/Reminders.app/"; }
  #     # { path = "/Applications/TablePlus.app/"; }
  #     {
  #       path = "${config.users.users.${user}.home}/Downloads";
  #       section = "others";
  #       options = "--sort name --view grid --display folder";
  #     }
  #   ];
  # };

}
