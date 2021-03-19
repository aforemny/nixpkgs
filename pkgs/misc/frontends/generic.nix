part: exe:
  let
    bin = if exe == "cli" then part else "${part}-${exe}";
  in
  { stdenv, lib, fetchurl, libressl }:
  stdenv.mkDerivation rec {
    pname = bin;
    version = "0.4";
    src = fetchurl {
      url = "https://www.codemadness.org/releases/frontends/frontends-${version}.tar.gz";
      hash = "sha256-ajbyV/6O5rbnetomJEVq+MT9mKg/94wooz4FKdXNvEk=";
    };
    patches = [
      ./linux-build.patch
      ./dynamic-linking.patch
    ];
    buildInputs = [ libressl ];
    buildPhase = "make ${part}/${exe}";
    installPhase = ''
      mkdir -p $out/bin
      cp ${part}/${exe} $out/bin/${bin}
    '';
    meta = with lib; {
      description = "A ${exe} frontend for ${part} by codemadness.org";
      homepage = "https://www.codemadness.org/idiotbox.html";
      license = licenses.isc;
      maintainers = [];
      platforms = platforms.linux;
    };
  }
