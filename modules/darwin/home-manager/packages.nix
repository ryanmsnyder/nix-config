{ pkgs }:

let 
  sharedPackagesSet = import ../../shared/home-manager/packages.nix { inherit pkgs; };
  sharedNonGuiPackages = sharedPackagesSet.shared-non-gui-pkgs;
  sharedGuiPackages = sharedPackagesSet.shared-gui-pkgs;
  sharedMacOSPackages = sharedPackagesSet.shared-macos-pkgs;

in
  with pkgs;
  sharedNonGuiPackages ++ 
  sharedGuiPackages ++ 
  sharedMacOSPackages
