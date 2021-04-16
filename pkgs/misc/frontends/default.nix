{ callPackage }:
let
  drvFor = import ./generic.nix;
in
{
  duckduckgo = callPackage (drvFor "duckduckgo" "cli") {};
  duckduckgo-gopher = callPackage (drvFor "duckduckgo" "gopher") {};
  reddit = callPackage (drvFor "reddit" "cli") {};
  reddit-cgi = callPackage (drvFor "reddit" "cgi") {};
  reddit-gopher = callPackage (drvFor "reddit" "gopher") {};
  twitch = callPackage (drvFor "twitch" "cli") {};
  twitch-cgi = callPackage (drvFor "twitch" "cgi") {};
  twitch-gopher = callPackage (drvFor "twitch" "gopher") {};
  youtube = callPackage (drvFor "youtube" "cli") {};
  youtube-cgi = callPackage (drvFor "youtube" "cgi") {};
  youtube-gopher = callPackage (drvFor "youtube" "gopher") {};
}
