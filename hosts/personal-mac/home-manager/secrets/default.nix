{ pkgs, user, inputs, ... }:

{
  age = {
    identityPaths = [
      "/Users/${user}/.ssh/agenix-id_ed25519"
    ];
    secrets = {
      home-assistant-ssh-private-key = {
        symlink = true;
        path = "/Users/${user}/.ssh/home-assistant-id_ed25519";
        file = "${inputs.secrets}/home-assistant-ssh-private-key.age";
        mode = "600";
      };

      office-pi-ssh-private-key = {
        symlink = true;
        path = "/Users/${user}/.ssh/office-pi-id_ed25519";
        file = "${inputs.secrets}/office-pi-ssh-private-key.age";
        mode = "600";
      };
    };
  };
}
