final: prev: {
  macwhisper = final.stdenv.mkDerivation rec {
    pname = "macwhisper";
    version = "1"; 

    src = final.fetchurl {
      # to find the newest version, check the homebrew cask JSON here:
      # https://formulae.brew.sh/api/cask/macwhisper.json
      url = "https://stickytimers.app/macwhisper/MacWhisper-1164.zip";
      sha256 = "jERSoeu1pnSDTHeQkom31q00HLQkzYRThX+VF2hHZ/g=";
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
