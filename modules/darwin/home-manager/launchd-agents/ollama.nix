{ config, pkgs, lib, ... }:

with lib;
let
  scripts = import ../scripts { inherit pkgs; }; # Import scripts module
in
{
  launchd.agents.ollama = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          # Start Ollama in the background
          ${pkgs.ollama}/bin/ollama serve &

          # Give it a few seconds to start
          sleep 3

          # Check if Ollama is running
          if pgrep -f "ollama serve" > /dev/null; then
            ${scripts.notifyServiceScript}/bin/notify-service "Ollama" "Started successfully."
            echo "$(date) - Ollama started successfully." >> /tmp/ollama.log
            exit 0
          else
            ${scripts.notifyServiceScript}/bin/notify-service "Ollama" "Failed to start."
            echo "$(date) - Ollama failed to start." >> /tmp/ollama-error.log
            exit 1
          fi
        ''
      ];
      RunAtLoad = true;   # Start automatically at login
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Background";
      StandardOutPath = "/tmp/ollama.log";  # Log output
      StandardErrorPath = "/tmp/ollama-error.log";  # Log errors
    };
  };
}
