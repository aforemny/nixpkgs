{ callPackage }:
let
  drvFor = import ./generic.nix;
in
{
  duckduckgo-gopher = callPackage (drvFor "duckduckgo" "gopher") {};
  duckduckgo = callPackage (drvFor "duckduckgo" "cli") {};
  reddit-gopher = callPackage (drvFor "reddit" "gopher") {};
  reddit = callPackage (drvFor "reddit" "cli") {};
  youtube-cgi = callPackage (drvFor "youtube" "cgi") {};
  youtube-gopher = callPackage (drvFor "youtube" "gopher") {};
  youtube = callPackage (drvFor "youtube" "cli") {};
}
