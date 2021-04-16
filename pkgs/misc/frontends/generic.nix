part: exe:
  let
    bin = if exe == "cli" then part else "${part}-${exe}";
  in
  { stdenv, lib, fetchurl, libressl }:
  stdenv.mkDerivation rec {
    pname = bin;
    version = "0.4";
    #version = "2021-04-16";
    #src = fetchgit {
    #  url = "git://git.codemadness.org/frontends";
    #  rev = "9b267a7fb5fc713932a218745a6e5a9ff27818ab";
    #  sha256 = "sha256-YuJV8QTJiGgOXklv73orVr6ylqD7ejytg8QCiPHPZ5s=";
    #};
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

      if [[ ${exe} = 'cgi' ]]; then
        if [[ -d ${part}/css ]]; then
          mkdir -p $out/share
          cp -r ${part}/css $out/share
        fi
      fi
    '';
    meta = with lib; {
      description = "A ${exe} frontend for ${part} by codemadness.org";
      homepage = "https://www.codemadness.org/idiotbox.html";
      license = licenses.isc;
      maintainers = [];
      platforms = platforms.linux;
    };
  }
