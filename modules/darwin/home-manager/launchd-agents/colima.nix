{ config, pkgs, lib, ... }:

with lib;
let
  username = config.home.username;
  isAarch64 = pkgs.stdenv.system == "aarch64-darwin"; # Detect Apple Silicon
  scripts = import ../scripts { inherit pkgs; }; # Import scripts module
in
{
  launchd.agents.colima = {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = "/Users/${username}/.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      ProgramArguments = mkMerge [
        [
          "${scripts.notifyServiceScript}/bin/notify-service"
          "Colima"
          "${pkgs.colima}/bin/colima"
          "start"
          "--foreground"
        ]
        (mkIf isAarch64 [
          "--arch" "aarch64"
          "--vm-type" "vz"
          "--vz-rosetta"
        ])
      ];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Interactive";
    };
  };
}
