{ config, pkgs, ... }:

let user = "ryan"; in

{

  imports = [
    ../../darwin/home-manager
    ../../shared
    ../../shared/cachix
    ../../darwin/system-config.nix
    ../../darwin/home-manager/dockutil.nix
  ];

  # Configure applications that should appear in Dock
  local = {
    dock.enable = true;
    dock.entries = [
      # { path = "/Applications/Slack.app/"; }
      # { path = "/System/Applications/Messages.app/"; }
      # { path = "/System/Applications/Facetime.app/"; }
      # { path = "/Applications/Telegram.app/"; }
      { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
      # { path = "/System/Applications/Music.app/"; }
      # { path = "/System/Applications/News.app/"; }
      # { path = "/System/Applications/Photos.app/"; }
      # { path = "/System/Applications/Photo Booth.app/"; }
      # { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Bruno.app"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app/"; }
      { path = "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"; }
      { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
      { path = "/System/Applications/Reminders.app/"; }
      # { path = "/Applications/TablePlus.app/"; }
      # { path = "/Applications/Drafts.app/"; }
      # { path = "/System/Applications/Home.app/"; }
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
    ];
  };


}
