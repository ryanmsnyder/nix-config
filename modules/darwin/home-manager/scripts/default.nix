{ pkgs }:

{
  # create script that converts timestamp to date
  # automatically installs node because of the shebang {pkgs.nodejs}
  tsScript = pkgs.writeScriptBin "ts" ''
            #!${pkgs.nodejs}/bin/node
            const ts = +process.argv[2]
            console.log(new Date(ts > 1000000000000 ? ts : ts * 1000))
          '';

  # Notification script for any launchd service
  notifyServiceScript = pkgs.writeScriptBin "notify-service" ''
    #!${pkgs.bash}/bin/bash

    service_name="$1"  # First argument is the service name (notification title)
    shift

    if [ "$#" -eq 1 ]; then
      # If only one argument is passed, it's a pure message → display notification
      osascript -e "display notification \"$1\" with title \"$service_name\""
      exit 0
    fi

    command="$@"
    output="$($command 2>&1)"
    err="$?"

    if [ "$err" -ne 0 ]; then
      osascript -e "display notification \"Failed: $output\" with title \"$service_name\""
      exit "$err"
    else
      osascript -e "display notification \"Started successfully\" with title \"$service_name\""
    fi
  '';
}
