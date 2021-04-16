{ name }:
{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.codemadness-frontends."${name}";

  pkg = pkgs.frontends."${name}-cgi";
in {
  options.services.codemadness-frontends."${name}" = {
    enable = mkEnableOption "${name} frontend";
  };

  config = mkIf cfg.enable {

    services.nginx.enable = true;
    services.fcgiwrap.enable = true;

    networking.extraHosts = "127.0.0.1 ${name}.local";

    services.nginx.virtualHosts."${name}.local" = {
      listen = [ { addr = "0.0.0.0"; port = 80; } ];
      locations = {
        "/css/".root = "${pkg}/share";
        "/".extraConfig = ''
          gzip off;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_pass unix:${config.services.fcgiwrap.socketAddress};
          fastcgi_param SCRIPT_FILENAME ${pkg}/bin/${name}-cgi;
          fastcgi_param SCRIPT_NAME ${pkg}/bin/${name}-cgi;
          fastcgi_param REQUEST_URI ${pkg}/bin/${name}-cgi;
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [];
}
