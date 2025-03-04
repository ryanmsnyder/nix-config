{ config, pkgs, lib, ... }:

with lib;
let
  username = config.home.username;
  homeDir = config.home.homeDirectory;
  notifyService = "${homeDir}/.nix-profile/bin/notify-service";
  ollamaBinary = "${pkgs.ollama}/bin/ollama";
in
{
  launchd.agents.ollama = {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = "${homeDir}/.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          # Start Ollama in the foreground so launchd keeps tracking it
          ${ollamaBinary} serve &

          # Wait a few seconds to check if it's running
          sleep 3

          # Check if Ollama is running
          if pgrep -f "${ollamaBinary} serve" > /dev/null; then
            ${notifyService} "Ollama" "Ollama is running successfully."
          else
            ${notifyService} "Ollama" "Error: Ollama failed to start."
          fi

          # Keep the process running so launchd does not terminate it
          wait
        ''
      ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
      };
      ProcessType = "Background";
    };
  };
}
