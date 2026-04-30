{ ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.userSettings = {
      "update.mode" = "none";
      "extensions.autoUpdate" = false;
      "extensions.autoCheckUpdates" = false;
      "telemetry.telemetryLevel" = "off";
    };
  };
}
