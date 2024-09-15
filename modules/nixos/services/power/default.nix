{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.power;
in
{
  options.${namespace}.services.power = {
    enable = mkEnableOption "Power profiles";
  };

  config = mkIf cfg.enable { services.power-profiles-daemon.enable = cfg.enable; };
}
