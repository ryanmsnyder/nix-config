{ config, pkgs, lib, ... }:

with lib;
let
  username = config.home.username;
  isAarch64 = pkgs.stdenv.system == "aarch64-darwin"; # Detect Apple Silicon
in
{
  launchd.agents.colima = {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = "/Users/${username}/.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--foreground"
      ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Interactive";
    };
  };
}
