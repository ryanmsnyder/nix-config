{ pkgs }:

let 
  sharedPackages = import ../shared/packages.nix { inherit pkgs; };

  customDarwinPackagesPath = ./custom-packages;
  customDarwinPackages = let
    isNixFile = name: builtins.match ".*\\.nix$" name != null;
    readCustomPackages = dirname: 
      builtins.filter isNixFile (builtins.attrNames (builtins.readDir dirname));

    loadPackage = name: pkgs.callPackage (builtins.path { path = customDarwinPackagesPath + "/${name}"; }) {};
  in
    builtins.map loadPackage (readCustomPackages customDarwinPackagesPath);

in
  sharedPackages ++ customDarwinPackages ++ [
    pkgs.dockutil
  ]
