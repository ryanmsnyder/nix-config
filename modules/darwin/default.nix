{ config, pkgs, user, ... }:

{
  # Darwin module entry point - imports all nix-darwin system configuration
  imports = [
    ./system-config.nix
    ./home-manager
  ];
}
