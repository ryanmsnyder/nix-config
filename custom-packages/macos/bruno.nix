# Bruno is an API tool like Postman (there was only a Linux package in nixpkgs)
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "bruno";
  version = "1.5.1";  # Replace with the desired version of Bruno

  src = pkgs.fetchurl {
    url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_arm64_mac.zip";  # URL for the arm64 architecture
    sha256 = "sha256-3Sm2mx6ICOGTcDz8LU7t9C+mh+gZ9Z31eofvTgf+Suc=";  # Replace with the correct hash
  };

  nativeBuildInputs = [ pkgs.unzip ];

  # Assuming Bruno does not require additional build steps or fixup
  dontFixup = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Bruno.app $out/Applications/
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "An open-source IDE for exploring and testing APIs";
    homepage = "https://github.com/usebruno/bruno";
    license = licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
