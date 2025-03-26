{ config, pkgs, lib, inputs, ... }:

{
  # Import config for home-manager programs
  imports = [
    ./theme.nix
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
    ./programs/btop.nix
    ./programs/direnv.nix
    ./programs/fd.nix
    ./programs/kitty.nix
    ./programs/ripgrep.nix
    ./programs/jq.nix
  ];


  # Set theme globally
  config = {
    theme = "catppuccin";  # Main theme
    flavor = "mocha";      # Change theme flavor (latte, frappe, macchiato, mocha)

    # Environment variables
    home.sessionVariables = {
      LESS = "-R";
      PAGER = "bat";
    };
  };
  
}
