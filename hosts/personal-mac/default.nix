{ config, pkgs, user, ... }:

{
  imports = [
    ./home-manager
    ./dock.nix
    ../../modules/darwin
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # Dock configuration imported from ./dock.nix

}
