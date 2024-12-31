final: prev: {
  forklift = final.stdenv.mkDerivation rec {
    pname = "forklift";
    version = "4"; 

    src = final.fetchurl {
      url = "https://download.binarynights.com/ForkLift/ForkLift4.zip";
      sha256 = "7aj+8xEydqFH1tchNniqbDzh5BBxjTKJ4816D30KMhk=";
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
