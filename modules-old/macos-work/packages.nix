{ pkgs }:

let 
  sharedPackagesSet = import ../shared/packages.nix { inherit pkgs; };
  sharedCommandLinePackages = sharedPackagesSet.shared-command-line-pkgs;
  sharedGuiPackages = sharedPackagesSet.shared-gui-pkgs;
  sharedMacOSPackages = sharedPackagesSet.shared-macos-pkgs;

  # customDarwinPackagesPath = ../../custom-packages/macos;

  # # Directly import the bruno.nix package
  # brunoDarwin = pkgs.callPackage (customDarwinPackagesPath + "/bruno.nix") {};

in
  with pkgs;
  sharedCommandLinePackages ++ 
  sharedGuiPackages ++ 
  sharedMacOSPackages ++ 
  [
    # Packages specific to MacOS personal machine
    qbittorrent
  ]
