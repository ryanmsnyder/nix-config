{ lib, ... }:

{
  options = {
    users.myUser = lib.mkOption {
      type = lib.types.str;
      default = "ryan";
      description = "Username for the user configuration.";
    };
  };

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    nixpkgs.overlays =
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };
}
