let
  # set base path to the root of the config directory relative to this overlay
  basePath = ../.;
in
self: super: with super; {
  berkeley-mono-font = let
    version = "1.0";
    pname = "berkeley-mono-font";
    # Directly specify the path to the TTF file relative to this Nix file
    ttfFile = "${basePath}/modules/home-manager/files/BerkeleyMono-Regular.ttf";
  in stdenv.mkDerivation {
    name = "${pname}-${version}";

    # Since we are manually handling the file, `src` is not needed for fetching
    # but we still need to specify something to satisfy mkDerivation
    src = ./.;

    buildInputs = [ ];

    # No need for multiple phases if only copying a file
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp ${ttfFile} $out/share/fonts/truetype/
    '';

    meta = with lib; {
      homepage = "https://berkeleymono.com/";
      description = "Berkeley Mono, a monospaced font designed for coding and text";
      license = licenses.mit;
      maintainers = [ maintainers.ryanmsnyder ];
      platforms = [ platforms.aarch64-darwin ];
    };
  };
}
