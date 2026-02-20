{ config, pkgs, lib, user, ... }:

{
  # Host-specific SSH configuration for work-macbookpro
  # Note: SSH is already enabled in shared config, we're just adding matchBlocks
  programs.ssh.matchBlocks = {

    # Home Assistant
    "ha" = {
      hostname = "192.168.1.2";
      user = "root";
      port = 22;
      identityFile = "~/.ssh/home-assistant-id_ed25519";
    };

    # GitHub (work uses HTTPS for GitHub, but SSH config needed for personal projects)
    "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/github-id_ed25519";
      identitiesOnly = true;
    };
  };
}
