{ config, pkgs, lib, user, ... }:

let user = "ryan";

in

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        # Default SSH settings
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };
    };
  };
}
