{ config, pkgs, lib, ... }:

let
    name = "Ryan Snyder";
    user = "ryansnyder";
    email = "ryansnyder4@gmail.com";
in

{
  imports = [
    ./programs/git.nix
    ./programs/lf.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];
}
