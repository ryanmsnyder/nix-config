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

      context7-api-key = {
        symlink = false;
        path = "/Users/${user}/.config/claude/context7-api-key";
        file = "${inputs.secrets}/context7-api-key-personal.age";
        mode = "600";
      };

      ha-mcp-token = {
        symlink = false;
        path = "/Users/${user}/.config/claude/ha-mcp-token";
        file = "${inputs.secrets}/ha-mcp-token-personal.age";
        mode = "600";
      };
    };
  };
}
