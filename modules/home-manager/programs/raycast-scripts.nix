{ config, pkgs, lib, ... }:

{
  # Declaratively manage Raycast script commands
  # Scripts will be placed in ~/.config/raycast/scripts
  home.file = {
    # VPN Connection Script
    ".config/raycast/scripts/connect-vpn.sh" = {
      text = ''
        #!/bin/zsh

        # @raycast.schemaVersion 1
        # @raycast.title Connect VPN
        # @raycast.mode silent
        # @raycast.icon 🔒
        # @raycast.packageName VPN

        MASTER_PASS=$(security find-generic-password -s "cisco-vpn" -a "ryan.snyder" -w 2>/dev/null)

        if [ -z "$MASTER_PASS" ]; then
          osascript -e 'display notification "Could not retrieve password from Keychain" with title "❌ VPN Error" sound name "Basso"'
          exit 1
        fi

        /opt/cisco/secureclient/bin/vpn -s connect http://p-rmdev.r-vpn.net <<EOF
        ryan.snyder
        $MASTER_PASS
        exit
        EOF

        # Wait a moment for connection to establish
        sleep 2

        if /opt/cisco/secureclient/bin/vpn state | grep -q "Connected"; then
          osascript -e 'display notification "Connected to p-rmdev.r-vpn.net" with title "🔒 VPN Connected" sound name "Glass"'
        else
          osascript -e 'display notification "Failed to connect to VPN" with title "❌ VPN Error" sound name "Basso"'
          exit 1
        fi
      '';
      executable = true;
    };

    # VPN Disconnect Script
    ".config/raycast/scripts/disconnect-vpn.sh" = {
      text = ''
        #!/bin/zsh

        # @raycast.schemaVersion 1
        # @raycast.title Disconnect VPN
        # @raycast.mode silent
        # @raycast.icon 🔓
        # @raycast.packageName VPN

        /opt/cisco/secureclient/bin/vpn disconnect

        # Wait a moment for disconnection
        sleep 1

        if /opt/cisco/secureclient/bin/vpn state | grep -q "Disconnected"; then
          osascript -e 'display notification "Disconnected from VPN" with title "🔓 VPN Disconnected" sound name "Glass"'
        else
          osascript -e 'display notification "Failed to disconnect from VPN" with title "❌ VPN Error" sound name "Basso"'
          exit 1
        fi
      '';
      executable = true;
    };

    # VPN Status Script
    ".config/raycast/scripts/vpn-status.sh" = {
      text = ''
        #!/bin/zsh

        # @raycast.schemaVersion 1
        # @raycast.title VPN Status
        # @raycast.mode inline
        # @raycast.icon 📊
        # @raycast.packageName VPN

        if /opt/cisco/secureclient/bin/vpn state | grep -q "Connected"; then
          echo "✅"
        else
          echo "❌"
        fi
      '';
      executable = true;
    };
  };
}
