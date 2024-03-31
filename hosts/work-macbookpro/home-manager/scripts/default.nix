{ pkgs }:

{
  myScript = pkgs.writeScriptBin "myScript" ''
    #!/usr/bin/env sh
    echo "Hello, world!"
  '';
}
