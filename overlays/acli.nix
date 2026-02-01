final: prev: {
  acli = final.stdenv.mkDerivation rec {
    pname = "acli";
    version = "latest";

    src = final.fetchurl {
      url = "https://acli.atlassian.com/darwin/latest/acli_darwin_arm64/acli";
      sha256 = "sha256-zp8bqVaR48u07legN7J1xiBl7SaIG6Ki6PU17/UfwSI=";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp $src $out/bin/acli
      chmod +x $out/bin/acli
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Atlassian CLI for Jira, Confluence, and other Atlassian products";
      homepage = "https://developer.atlassian.com/cloud/acli/";
      platforms = [ "aarch64-darwin" ];
    };
  };
}
