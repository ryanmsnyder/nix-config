final: prev: {
  macwhisper = final.stdenv.mkDerivation rec {
    pname = "macwhisper";
    version = "1"; 

    src = final.fetchurl {
      url = "https://stickytimers.app/macwhisper/MacWhisper.zip";
      sha256 = "DCUnGp4t3joeOgDzl41nhDkrURSFTfLxrVEA3M4ZdRs=";
    };

    nativeBuildInputs = [ final.unzip ];

    dontFixup = true;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      unzip -o $src -d $out
      mkdir -p $out/Applications
      mv "$out/MacWhisper.app" $out/Applications/
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Quickly and easily transcribe audio files into text with state-of-the-art transcription technology";
      homepage = "https://goodsnooze.gumroad.com/l/macwhisper";
      license = licenses.unfree;
      platforms = [ "aarch64-darwin" ];
    };
  };
}
