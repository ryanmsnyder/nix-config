{ pkgs }:

let 
  sharedPackagesSet = import ../shared/packages.nix { inherit pkgs; };
  sharedCommandLinePackages = sharedPackagesSet.shared-command-line-pkgs;
  sharedGuiPackages = sharedPackagesSet.shared-gui-pkgs;
  sharedMacOSPackages = sharedPackagesSet.shared-macos-pkgs;

  customDarwinPackagesPath = ./custom-packages;
  customDarwinPackages = let
    isNixFile = name: builtins.match ".*\\.nix$" name != null;
    readCustomPackages = dirname: 
      builtins.filter isNixFile (builtins.attrNames (builtins.readDir dirname));

    loadPackage = name: pkgs.callPackage (builtins.path { path = customDarwinPackagesPath + "/${name}"; }) {};
  in
    builtins.map loadPackage (readCustomPackages customDarwinPackagesPath);

in
  with pkgs;
  sharedCommandLinePackages ++ 
  sharedGuiPackages ++ 
  sharedMacOSPackages ++ 
  customDarwinPackages ++ 
  [
    # Packages specific to MacOS personal machine
    qbittorrent
  ]
