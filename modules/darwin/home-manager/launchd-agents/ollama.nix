{ config, pkgs, lib, ... }:

with lib;

{
  launchd.agents.ollama = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.ollama}/bin/ollama"
        "serve"
      ];
      RunAtLoad = true;   # Start automatically at login
      KeepAlive = true;   # Restart if the process stops
      ProcessType = "Background";
      StandardOutPath = "/tmp/ollama.log";  # Log output
      StandardErrorPath = "/tmp/ollama-error.log";  # Log errors
    };
  };
}
