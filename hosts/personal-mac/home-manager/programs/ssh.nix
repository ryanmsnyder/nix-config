{ config, pkgs, lib, user, ... }:

{
  # Host-specific SSH configuration for personal-mac
  # Note: SSH is already enabled in shared config, we're just adding matchBlocks
  programs.ssh.matchBlocks = {
    
    # Raspberry pi zero w used as ddc monitor input switcher and usb switcher
    "ddc-switcher" = {
      hostname = "ddc-switcher.local";
      user = "ryan";
      port = 22;
      identityFile = "~/.ssh/ddc-switcher-id_ed25519";

    };
    
    # Home Assistant
    "ha" = {
      hostname = "192.168.1.2";
      user = "root";
      port = 22;
      identityFile = "~/.ssh/home-assistant-id_ed25519";
    };
    
    # GitHub
    "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/github-id_ed25519";
      identitiesOnly = true;
    };
  };
}
