{ config, pkgs, lib, ... }:

let
  # Define common variables that will be passed to each module
  name = "Ryan Snyder";
  user = "ryansnyder";
  email = "ryansnyder4@gmail.com";

  # Function to import all Nix files from a given directory
  importDirectory = dir: 
    let
      # The path to the directory containing the Nix files
      path = dir;

      # Filter out all files in the directory ending with '.nix'
      files = builtins.filter (x: lib.strings.hasSuffix ".nix" x) (builtins.attrNames (builtins.readDir path));

    in 
      # Convert the list of file names into an attribute set
      # Each file is imported and its name (without the .nix extension) is used as the key
      builtins.listToAttrs (map (fileName: 
        let 
          # Extract the module name from the file name
          name = lib.strings.removeSuffix ".nix" fileName;
        in 
          # Create a key-value pair for each module
          lib.nameValuePair name (import (path + "/${fileName}") { inherit config pkgs lib name user email; })
        ) files);

  # Import all configurations from the 'programs' directory
  programConfigs = importDirectory ./programs;
in
  # Return the imported configurations
  programConfigs
