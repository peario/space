{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    getExe'
    ;

  cfg = config.${namespace}.services.spice-webdav;
in
{
  options.${namespace}.services.spice-webdav = with types; {
    enable = mkEnableOption "spice-webdav proxy support";
    package = mkOption {
      default = pkgs.phodav;
      defaultText = literalExpression "pkgs.phodav";
      description = "spice-webdavd provider package to use.";
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    services = {
      # ensure the webdav fs this exposes can actually be mounted
      davfs2.enable = true;

      # add the udev rule which starts the proxy when the spice socket is present
      udev.packages = [ cfg.package ];
    };

    systemd.services.spice-webdavd = {
      description = "spice-webdav proxy daemon";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe' cfg.package "spice-webdavd"} -p 9843";
        Restart = "on-success";
      };

      wantedBy = [ "graphical.target" ];
    };
  };
}
