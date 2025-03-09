{ config, pkgs, lib, inputs, ... }:

{
  # Import config for home-manager programs
  imports = [
    ./theme.nix
    # inputs.catppuccin.homeManagerModules.catppuccin
    ./programs/wezterm.nix
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
