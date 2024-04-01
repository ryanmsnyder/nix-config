{ pkgs }:

let
  vpnConnectScript = ./vpn-connect.sh;
in
{
  myScript = pkgs.writeScriptBin "myScript" ''
    #!/usr/bin/env sh
    echo "Hello, world!"
  '';

  anotherScript = pkgs.writeScriptBin "anotherScript" ''
    #!/usr/bin/env bash
    echo "This is another script."
  '';

  vpnConnect = pkgs.writeShellScriptBin "vpn-connect" (builtins.readFile vpnConnectScript);
}
