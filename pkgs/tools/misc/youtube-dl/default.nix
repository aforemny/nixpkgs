{ lib, fetchurl, fetchpatch, buildPythonPackage
, zip, ffmpeg, rtmpdump, atomicparsley, pycryptodome, pandoc
# Pandoc is required to build the package's man page. Release tarballs contain a
# formatted man page already, though, it will still be installed. We keep the
# manpage argument in place in case someone wants to use this derivation to
# build a Git version of the tool that doesn't have the formatted man page
# included.
, generateManPage ? false
, ffmpegSupport ? true
, rtmpSupport ? true
, hlsEncryptedSupport ? true
, installShellFiles, makeWrapper }:

buildPythonPackage rec {

  pname = "youtube-dl";
  # The websites youtube-dl deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2023.08.07";

  src = fetchurl {
    url = "https://github.com/ytdl-org/ytdl-nightly/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-t5k5IqNsA8x78zot51iNOCzJDhYdDwgp99jSSgA638c=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ zip ] ++ lib.optional generateManPage pandoc;
  propagatedBuildInputs = lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs = let
      packagesToBinPath =
        [ atomicparsley ]
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump;
    in [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  meta = with lib; {
    homepage = "https://ytdl-org.github.io/youtube-dl/";
    description = "Command-line tool to download videos from YouTube.com and other sites";
    longDescription = ''
      youtube-dl is a small, Python-based command-line program to download
      videos from YouTube.com and a few more sites.  youtube-dl is released to
      the public domain, which means you can modify it, redistribute it or use
      it however you like.
    '';
    license = licenses.publicDomain;
    maintainers = with maintainers; [ bluescreen303 fpletz ];
    platforms = with platforms; linux ++ darwin;
  };
}
