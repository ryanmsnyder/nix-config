{ config, pkgs, user, ... }: 

{
  imports = [
    ./dock.nix
    ./users.nix
    ./homebrew.nix
    ./system-defaults.nix
    ./launchd-services.nix
    ./activation-scripts.nix
  ];

  # Install karabiner-elements. The config file is symlinked as part of home-manager
  services.karabiner-elements.enable = true;

  # Web UI for open source LLMs (formerly ollama-webui)
  # services.open-webui.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixVersions.latest;
    settings.trusted-users = [ "@admin" user ];

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids configurable-impure-env
    '';
  };

  system.primaryUser = user;

  # Fix for nix build user group GID mismatch
  ids.gids.nixbld = 350;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Enable fonts dir
  # fonts.fontDir.enable = true;

  system.stateVersion = 4;

}
