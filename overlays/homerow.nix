final: prev: {
  homerow = final.stdenv.mkDerivation rec {
    pname = "homerow";
    version = "1"; 

    src = final.fetchurl {
      url = "https://builds.homerow.app/v1.3.3/Homerow.zip";
      sha256 = "mQAcRc9N0CbTg6NC6P4SbIcxp4b8lQocdRinGdnFl8o=";
    };

    nativeBuildInputs = [ final.unzip ];

    dontFixup = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      unzip -o $src -d $out
      mkdir -p $out/Applications
      mv "$out/Homerow.app" $out/Applications/
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Keyboard shortcuts for every button in macOS";
      homepage = "https://www.homerow.app";
      license = licenses.unfree;
      platforms = [ "aarch64-darwin" ];
    };
  };
}
