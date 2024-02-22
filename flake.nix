{
  description = "Configuration for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, darwin, nix-homebrew, home-manager, nixpkgs, disko } @inputs:
  # outputs = { self, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, home-manager, nixpkgs, disko } @inputs:
    let
      user = "ryan";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };

      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkLinuxApps = system: {
        "apply" = mkApp "apply" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "install" = mkApp "install" system;
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = let user = "ryan"; in {
        macbookpro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs;}; # this allows inputs to be passed explicitly to other modules
          modules = [
            home-manager.darwinModules.home-manager
            ./hosts/macbookpro
          ];
        };

        work-macbookpro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs;}; # this allows inputs to be passed explicitly to other modules
          modules = [
            home-manager.darwinModules.home-manager
            ./hosts/macos/work-macbookpro.nix
          ];
        };
      };

    #   nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.nixosSystem {
    #     inherit system;
    #     specialArgs = inputs;
    #     modules = [
    #       disko.nixosModules.disko
    #       home-manager.nixosModules.home-manager {
    #         home-manager = {
    #           useGlobalPkgs = true;
    #           useUserPackages = true;
    #           users.${user} = import ./modules/nixos/desktop/home-manager-desktop.nix;
    #         };
    #       }
    #       ./hosts/nixos
    #     ];
    #  });

      nixosConfigurations = {
        hetzner-vps = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs user; }; # this allows inputs to be passed explicitly to other modules
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager {
              home-manager = {
                extraSpecialArgs = { inherit user; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = import ./modules/nixos/home-manager.nix;
              };
            }
            ./hosts/hetzner-vps
          ];
        };
      };
  };
}
