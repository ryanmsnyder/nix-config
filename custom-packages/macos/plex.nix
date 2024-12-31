{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "plex";
  version = "1.41.3.9292-bc7397402"; 

  src = pkgs.fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/macos/PlexMediaServer-${version}-universal.zip";  # URL for the arm64 architecture
    sha256 = "0ca45fisa8l98g99nkzrhjgqi3g0iz4zjjp6mc7439jdgawr1s8z";
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
