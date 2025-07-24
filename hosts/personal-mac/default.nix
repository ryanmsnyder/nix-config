{ config, pkgs, user, ... }:

{
  imports = [
    ./home-manager
    ./dock.nix
    ../../modules/darwin/home-manager
    ../../modules/shared
    ../../modules/shared/cachix
    ../../modules/darwin/system-config.nix
  ];

  # Dock configuration imported from ./dock.nix

}
