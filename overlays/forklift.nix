final: prev: {
  forklift = final.stdenv.mkDerivation rec {
    pname = "forklift";
    version = "4"; 

    src = final.fetchurl {
      url = "https://download.binarynights.com/ForkLift/ForkLift4.2.1.zip";
      sha256 = "H49qS+0C8+oGuws6G5UzSp+0MURR8A8vFGrADgl9vUU=";
    };

    nativeBuildInputs = [ final.unzip ];

    dontFixup = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      unzip -o $src -d $out
      mkdir -p $out/Applications
      mv "$out/ForkLift.app" $out/Applications/
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "The most advanced dual pane file manager and file transfer client for macOS.";
      homepage = "https://binarynights.com";
      license = licenses.unfree;
      platforms = [ "aarch64-darwin" ];
    };
  };
}
