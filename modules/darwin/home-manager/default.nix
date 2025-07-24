{ config, pkgs, lib, home-manager, fullName, user, email, inputs, ... }:

let
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  darwinScripts = builtins.attrValues scripts;


in

{
  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs fullName user email;
    };

    users.${user} = {

      home = {
        enableNixpkgsReleaseCheck = false;
        # Packages/apps that will only be exposed to the user via ~/.nix-profile
        # packages = pkgs.callPackage ./packages.nix {};
        packages = pkgs.callPackage ./packages.nix {} ++ darwinScripts;
        # file = lib.mkMerge [
        #   sharedFiles
        #   additionalFiles
        # ];
        file.".config/karabiner/karabiner.json".source = ../../shared/home-manager/config/karabiner/karabiner.json;

        stateVersion = "23.11";
      };

      # Import home-manager programs shared between MacOS and nixOS
      imports = [
        ../../shared/home-manager
        ./launchd-agents
        # inputs.catppuccin.homeManagerModules.catppuccin
      ];


      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };
}
