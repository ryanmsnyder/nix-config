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

      ddc-switcher-ssh-private-key = {
        symlink = true;
        path = "/Users/${user}/.ssh/ddc-switcher-id_ed25519";
        file = "${inputs.secrets}/ddc-switcher-ssh-private-key.age";
        mode = "600";
      };
    };
  };
}
