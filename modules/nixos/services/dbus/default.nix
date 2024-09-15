{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.dbus;
in
{
  options.${namespace}.services.dbus = {
    enable = mkEnableOption "dbus";
  };

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;

      packages = with pkgs; [
        dconf
        gcr
        udisks2
      ];

      implementation = "broker";
    };
  };
}
