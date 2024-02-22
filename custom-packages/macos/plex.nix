{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "plex";
  version = "1.40.0.7998-c29d4c0c8"; 

  src = pkgs.fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/macos/PlexMediaServer-${version}-universal.zip";  # URL for the arm64 architecture
    sha256 = "Plk+JiHg3vn75zRq1EKFL/DE5nVd6ZLg5PVKAQDYcEo=";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  dontFixup = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    unzip -o $src -d $out
    mkdir -p $out/Applications
    mv "$out/Plex Media Server.app" $out/Applications/
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Media library streaming server";
    homepage = "https://plex.tv/";
    license = licenses.unfree;
    platforms = [ "aarch64-darwin" ];
  };
}

# https://downloads.plex.tv/plex-media-server-new/1.40.0.7998-c29d4c0c8/macos/PlexMediaServer-1.40.0.7998-c29d4c0c8-universal.zip