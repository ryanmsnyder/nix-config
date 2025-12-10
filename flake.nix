{
  description = "Configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/24.11-beta";
    # nixpkgs-unstable = {
    #   url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/ryanmsnyder/nix-secrets.git";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, agenix, secrets, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, home-manager, nixpkgs, catppuccin } @inputs:
    let
      variables = {
        fullName = "Ryan Snyder";
        personal = {
          user = "ryan";
          email = "ryansnyder4@gmail.com";
        };
        work = {
          user = "ryan.snyder";
          email = "ryan.snyder@rakuten.com";
        };
      };
      darwinSystems = [ "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs darwinSystems f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };

      mkApp = scriptfullName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptfullName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptfullName} for ${system}"
          exec ${self}/apps/${system}/${scriptfullName}
        '')}/bin/${scriptfullName}";
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
      apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;
      templates = import ./templates;

      darwinConfigurations = {
        personal-mac = let fullName = variables.fullName; user = variables.personal.user; email = variables.personal.email; in darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs fullName user email; }; # this allows inputs to be passed explicitly to other modules

          modules = [
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            ./hosts/personal-mac
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
          ];
        };

        work-macbookpro = let fullName = variables.fullName; user = variables.work.user; email = variables.work.email; in darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs fullName user email;}; # this allows inputs to be passed explicitly to other modules
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew  # for installing Mac App Store apps
            ./hosts/work-macbookpro
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
          ];
        };
      };

  };
}
