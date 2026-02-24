{ pkgs, user, inputs, ... }:

{
  age = {
    identityPaths = [
      "/Users/${user}/.ssh/agenix-id_ed25519"
    ];
    secrets = {
      context7-api-key = {
        symlink = false;
        path = "/Users/${user}/.config/claude/context7-api-key";
        file = "${inputs.secrets}/context7-api-key.age";
        mode = "600";
      };
    };
  };
}
