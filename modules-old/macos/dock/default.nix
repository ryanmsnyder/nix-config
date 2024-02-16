{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.dock;
  inherit (pkgs) stdenv dockutil;
in
{
  options = {
    local.dock.enable = mkOption {
      description = "Enable dock";
      default = stdenv.isDarwin;
      example = false;
    };

    local.dock.entries = mkOption
      {
        description = "Entries on the Dock";
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption { type = str; };
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
        readOnly = true;
      };
  };

  config =
    mkIf cfg.enable
      (
        let
          # Function to normalize a path by ensuring it ends with '/' if it's an app
          normalize = path: if hasSuffix ".app" path then path + "/" else path;
          # Converts a filesystem path into a URI format, replacing characters
          # that need encoding in URIs
          entryURI = path: "file://" + (builtins.replaceStrings
            [" "   "!"   "\""  "#"   "$"   "%"   "&"   "'"   "("   ")"]
            ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
            (normalize path)
          );
          # Concatenates all desired Dock entry URIs into a single string
          wantURIs = concatMapStrings
            (entry: "${entryURI entry.path}\n")
            cfg.entries;
          # Generates the dockutil command to add each entry to the Dock
          createEntries = concatMapStrings
            (entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n")
            cfg.entries;
        in
        {
           # Remove everything from the dock
           # Resolve the symlink to its original path, or use the path as is if it's not a symlink
           # Add the resolved path to the Dock and then restart the Dock to apply change
          system.activationScripts.postUserActivation.text = ''
            echo >&2 "Resetting and Setting up the Dock..."
            ${dockutil}/bin/dockutil --remove all
            ${concatMapStrings (entry: ''
              resolvedPath=$(/usr/bin/readlink "${entry.path}" || echo "${entry.path}")
              ${dockutil}/bin/dockutil --no-restart --add "$resolvedPath" --section ${entry.section} ${entry.options}
            '') cfg.entries}
            killall Dock
            echo >&2 "Dock setup complete."
          '';
        }
      );
}
