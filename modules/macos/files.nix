{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{

  # Raycast script to message Mariah
  "${xdg_dataHome}/bin/message-mariah" = {
    executable = true;
    text = ''
    #!/usr/bin/osascript

    # Required parameters:
    # @raycast.schemaVersion 1
    # @raycast.title Message Mariah
    # @raycast.mode compact

    # Optional parameters:
    # @raycast.icon 💬
    # @raycast.argument1 { "type": "text", "placeholder": "message" }

    on run argv
      tell application "Messages"
        set targetService to 1st account whose service type = iMessage
        set targetBuddy to participant "3364044137" of targetService
        send argv to targetBuddy
      end tell
    end run
    '';
  };
}
