{ config, pkgs, user, ... }:

let 
  # packages that should only be installed on this machine 
  hostSpecificPackages = with pkgs; [ qbittorrent plexDarwin ];

  # scripts that should only be installed on this machine 
  hostSpecificScripts = import ./home-manager/scripts { inherit pkgs; }; 
in

{

  imports = [
    ../../modules/darwin/home-manager
    ../../modules/shared
    ../../modules/shared/cachix
    ../../modules/darwin/system-config.nix
    ../../modules/darwin/home-manager/dockutil.nix
  ];

  home-manager.users.${user}.home = {
    # install packages via home-manager that are specific to this host/machine
    # these will be installed in addition to other packages defined in modules/darwin/home-manager/default.nix
    packages = hostSpecificPackages ++ hostSpecificScripts;
    file = {
      # create folder in ~/.config where raycast scripts will be
      # ".config/raycast/".source = ./config/raycast;
    };
  };

  # Configure applications that should appear in Dock
  local = {
    dock.enable = true;
    dock.entries = [
      { path = "${pkgs.wezterm}/Applications/WezTerm.app/"; }
      { path = "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"; }
      { path = "${config.users.users.${user}.home}/.nix-profile/Applications/Bruno.app"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app/"; }
      { path = "${pkgs.spotify}/Applications/Spotify.app/"; }
      { path = "${pkgs.spotify}/Applications/Slack.app/"; }
      # { path = "/Applications/TablePlus.app/"; }
      {
        path = "${config.users.users.${user}.home}/Downloads";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
    ];
  };


}
