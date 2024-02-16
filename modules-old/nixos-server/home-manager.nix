{ config, pkgs, lib, ... }:

let
  user = "ryan";
  xdg_configHome  = "/home/${user}/.config";
  # shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };

in
{
  # Import home-manager programs
  imports = [
    ../shared/home-manager.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {}; # FIXME: this is causing error because electron isn't a trusted package
    # file = shared-files // import ../files.nix { inherit user; };
    stateVersion = "21.05";
  };

}
