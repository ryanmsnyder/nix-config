{ pkgs, user, inputs, ... }:

let 
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  hostSpecificScripts = builtins.attrValues scripts;

  # Import custom Darwin
  customDarwinPackagesPath = ../../../custom-packages/macos;
  plexDarwin = pkgs.callPackage (customDarwinPackagesPath + "/plex.nix") {};

  # Define other host-specific packages (if any)
  hostSpecificPackages = with pkgs; [ 
    plexDarwin
    qbittorrent
  ];

  # Import secrets
  secretConfig = import ./secrets { inherit pkgs user inputs; };
in

{
  home-manager.users.${user} = {
    imports = [ inputs.agenix.homeManagerModules.default secretConfig ./programs/git.nix ];

    home = {
      # Install combined packages and scripts specific to this host/machine
      packages = hostSpecificPackages ++ hostSpecificScripts;
      file = {

        # Symlink GitHub public key to .ssh directory
        # ".ssh/github-id_ed25519.pub".source = ./secrets/github-id_ed25519.pub;
      };
    };
  };

  
}
