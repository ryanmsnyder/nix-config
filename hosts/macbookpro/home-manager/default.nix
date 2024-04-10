{ config, pkgs, user, inputs, ... }:

let 
  # Import the scripts
  scripts = import ./scripts { inherit pkgs; };

  # Define scripts as a separate variable
  hostSpecificScripts = builtins.attrValues scripts;

  # Define other host-specific packages (if any)
  hostSpecificPackages = with pkgs; [ 
    
  ];
in

{
  home-manager.users.${user} = {
    imports = [ inputs.agenix.homeManagerModules.default ];

    home = {
      # Install combined packages and scripts specific to this host/machine
      packages = hostSpecificPackages ++ hostSpecificScripts;
      file = {
        # Configuration for files and directories, if needed
      };
    };

    age = { 
      identityPaths = [ 
        "/Users/${user}/.ssh/agenix-id_ed25519"
      ];
      secrets = { 
        github-ssh-key = {
          symlink = true;
          path = "/Users/${user}/.ssh/github-id_ed25519";
          file = "${inputs.secrets}/github-ssh-key.age";
          mode = "600";
          # owner = "${user}";
          # group = "staff";
        };
      };
    };
  };
}
