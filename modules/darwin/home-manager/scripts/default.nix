
{ pkgs }:

{
  # create script that converts timestamp to date
  # automatically installs node because of the shebang {pkgs.nodejs}
  tsScript = pkgs.writeScriptBin "ts" ''
            #!${pkgs.nodejs}/bin/node
            const ts = +process.argv[2]
            console.log(new Date(ts > 1000000000000 ? ts : ts * 1000))
          '';
}
