{ config, pkgs, user, ... }:

{
  imports = [
    ./home-manager
    ./dock.nix
    ./homebrew.nix
    ../../modules/system
    ../../modules
    ../../modules/cachix
  ];

  # Dock configuration imported from ./dock.nix

}
