{ pkgs, user, inputs, ... }:

let 
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  hostSpecificScripts = builtins.attrValues scripts;

  # Define other host-specific packages (if any)
  hostSpecificPackages = with pkgs; [ 
  ];

  # Import secrets
  # secretConfig = import ./secrets { inherit pkgs user inputs; };
in

{
  home-manager.users.${user} = {
    imports = [ inputs.agenix.homeManagerModules.default ./programs/git.nix ];

    home = {
      # Install combined packages and scripts specific to this host/machine
      packages = hostSpecificPackages ++ hostSpecificScripts;
      file = {

      };
    };
  };
}
