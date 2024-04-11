{ pkgs, user, inputs, ... }:

{
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
      };
    };
  };
}
