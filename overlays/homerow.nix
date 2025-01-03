final: prev: {
  homerow = final.stdenv.mkDerivation rec {
    pname = "homerow";
    version = "1"; 

    src = final.fetchurl {
      url = "https://builds.homerow.app/latest/Homerow.zip";
      sha256 = "McF1ApTnw/n5A2/qUsm53VlIkTKah6dXeURYV53UczI=";
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
