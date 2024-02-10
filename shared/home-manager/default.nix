{ config, pkgs, lib, ... }:

let
    name = "Ryan Snyder";
    email = "ryansnyder4@gmail.com";
in

{
  # Import config for home-manager programs
  imports = [
    ./programs/bat.nix
    ./programs/git.nix
    ./programs/lf.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./programs/neovim.nix
  ];

  # Set shared environment variables
  home.sessionVariables = {
    # Set the EDITOR environment variable
    LESS="-R";
    PAGER="bat";
  };

  # TODO: find a better home for this. Since Wezterm is a package and not a home-manager program, 
  # I've linked the wezterm config to the ~/.config folder here. With programs such as lf, etc,
  # I linked their config inside of their dedicated file in the programs directory
  home.file.".config/wezterm".source = ./config/wezterm; 
}
