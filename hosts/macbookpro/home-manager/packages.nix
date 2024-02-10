{ pkgs }:

let 
  sharedPackagesSet = import ../../../shared/home-manager/packages.nix { inherit pkgs; };
  sharedCommandLinePackages = sharedPackagesSet.shared-command-line-pkgs;
  sharedGuiPackages = sharedPackagesSet.shared-gui-pkgs;
  sharedMacOSPackages = sharedPackagesSet.shared-macos-pkgs;

in
  with pkgs;
  sharedCommandLinePackages ++ 
  sharedGuiPackages ++ 
  sharedMacOSPackages ++ 
  
  # Packages specific to MacOS personal machine that will be installed system-wide
  [
    
  ]
