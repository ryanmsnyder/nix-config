{ config, pkgs, lib, inputs, fullName, user, email, ... }:

let
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  darwinScripts = builtins.attrValues scripts;

in

{
  # Import config for home-manager programs
  imports = [
    ./theme.nix
    # ./programs/wezterm.nix  # disabled for local plugin development
    ./programs/bat.nix
    ./programs/git.nix
    ./programs/lf.nix
    ./programs/lsd.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./programs/neovim.nix
    ./programs/fzf.nix
    ./programs/btop.nix
    ./programs/htop.nix
    ./programs/direnv.nix
    ./programs/fd.nix
    ./programs/kitty.nix
    ./programs/ripgrep.nix
    ./programs/jq.nix
    ./launchd-agents
  ];

  # Set theme globally
  config = {
    theme = "catppuccin";  # Main theme
    flavor = "mocha";      # Change theme flavor (latte, frappe, macchiato, mocha)

    home = {
      enableNixpkgsReleaseCheck = false;
      # Packages/apps that will only be exposed to the user via ~/.nix-profile
      packages = pkgs.callPackage ./packages.nix { inherit inputs; } ++ darwinScripts;

      file.".config/karabiner/karabiner.json".source = ./config/karabiner/karabiner.json;

      stateVersion = "23.11";

      # Environment variables
      sessionVariables = {
        LESS = "-R";
        PAGER = "bat";
        GOOGLE_CLOUD_PROJECT = "rm-gcp-bsa-dev";
        GOOGLE_CLOUD_LOCATION = "us-east4";
      };
    };

    # Marked broken Oct 20, 2022 check later to remove this
    # https://github.com/nix-community/home-manager/issues/3344
    manual.manpages.enable = false;
  };
}
