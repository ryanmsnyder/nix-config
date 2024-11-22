{ pkgs, user, inputs, ... }:

{
  age = {
    identityPaths = [
      "/Users/${user}/.ssh/agenix-id_ed25519"
    ];
    secrets = {
      test-secret = {
        symlink = true;
        path = "/Users/${user}/.ssh/test_secret_ed25519";
        file = "${inputs.secrets}/test-secret.age";
        mode = "600";
      };
    };
  };
}
