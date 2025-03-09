{ config, pkgs, lib, user, ... }:

with lib;
let
  isAarch64 = pkgs.stdenv.system == "aarch64-darwin"; # Detect Apple Silicon
in
{
  launchd.agents.colima = {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = "/Users/${user}/.nix-profile/bin:/etc/profiles/per-user/${user}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
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
