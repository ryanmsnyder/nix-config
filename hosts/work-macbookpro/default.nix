{ config, pkgs, user, ... }:

let 
  # Import the scripts
  scripts = import ./home-manager/scripts { inherit pkgs; };

  # Define scripts as a separate variable
  hostSpecificScripts = builtins.attrValues scripts;

  # Define other host-specific packages (if any)
  hostSpecificPackages = with pkgs; [ 
    
  ];
in

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
