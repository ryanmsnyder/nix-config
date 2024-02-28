{ config, pkgs, ... }: 

{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Install karabiner-elements. The config file is symlinked as part of home-manager
  services.karabiner-elements.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "@admin" config.users.myUser ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Enable fonts dir
  fonts.fontDir.enable = true;

  system.stateVersion = 4;

}
