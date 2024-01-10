{ config, pkgs, lib, ... }:

let
    name = "Ryan Snyder";
    user = "ryansnyder";
    email = "ryansnyder4@gmail.com";
in

{
  # Import config for home-manager programs
  imports = [
    ./programs/git.nix
    ./programs/lf.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  # Set shared environment variables
  home.sessionVariables = {
    # Set the EDITOR environment variable
    EDITOR = "vim";
    LESS="-R";
    PAGER="bat";
  };
}
