{ pkgs }:

{
  # Wrapper script for Claude Code VS Code extension to inherit Nix environment
  claudeWrapper = pkgs.writeScriptBin "claude-wrapper" ''
    #!${pkgs.bash}/bin/bash
    # Source nix-daemon to get proper PATH
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # Source home-manager environment if available
    if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi
    # Add nix profile paths
    export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"
    # Load direnv environment if available for current directory
    if command -v direnv &> /dev/null && [ -f .envrc ]; then
      eval "$(direnv export bash 2>/dev/null)"
    fi
    # VS Code passes the claude binary path as first arg, rest are arguments
    exec "$@"
  '';
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
