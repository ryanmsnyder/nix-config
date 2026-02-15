{ pkgs, user, inputs, ... }:

let 
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  hostSpecificScripts = builtins.attrValues scripts;

  # Define other host-specific packages (if any)
  hostSpecificPackages = with pkgs; [
    chatgpt
    discord
    qbittorrent
  ];

  # Import secrets
  secretConfig = import ./secrets { inherit pkgs user inputs; };
in

{
  home-manager.users.${user} = {
    imports = [ 
      inputs.agenix.homeManagerModules.default 
      secretConfig 
      ./programs/ssh.nix
    ];

    home = {
      # Install combined packages and scripts specific to this host/machine
      packages = hostSpecificPackages ++ hostSpecificScripts;
      file = {

        # Symlink GitHub public key to .ssh directory
        ".ssh/home-assistant-id_ed25519.pub".source = ./public-keys/home-assistant-id_ed25519.pub;
        ".ssh/office-pi-id_ed25519.pub".source = ./public-keys/office-pi-id_ed25519.pub;

      };
    };
  };
  
}
