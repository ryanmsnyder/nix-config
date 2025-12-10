{ config, pkgs, user, ... }:

{
  # Darwin system configuration entry point
  imports = [
    ./system-config.nix
  ];
}
