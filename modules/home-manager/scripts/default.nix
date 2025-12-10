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

    export DISPLAY=:0
    export PATH=/usr/bin:/bin:/usr/sbin:/sbin
    
    notifyServiceLog="/tmp/notify-service.log"
    echo "$(date) - Called notify-service with args: $@" >> "$notifyServiceLog"
    
    service_name="$1"
    shift
    
    if [ "$#" -eq 1 ]; then
      osascript -e "display notification \"$1\" with title \"$service_name\""
      echo "$(date) - Sent notification: $1" >> "$notifyServiceLog"
      exit 0
    fi
    
    command="$@"
    output="$(eval "$command" 2>&1)"
    err="$?"
    
    echo "$(date) - Output: $output" >> "$notifyServiceLog"
    echo "$(date) - Exit Code: $err" >> "$notifyServiceLog"
    
    if [ "$err" -ne 0 ]; then
      osascript -e "display notification \"Failed: $output\" with title \"$service_name\""
      echo "$(date) - Notification sent for failure" >> "$notifyServiceLog"
      exit "$err"
    else
      osascript -e "display notification \"Started successfully\" with title \"$service_name\""
      echo "$(date) - Notification sent for success" >> "$notifyServiceLog"
    fi
  '';
}
