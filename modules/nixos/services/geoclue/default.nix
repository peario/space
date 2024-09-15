{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.geoclue;
in
{
  options.${namespace}.services.geoclue = {
    enable = mkEnableOption "Geoclue";
  };

  config = mkIf cfg.enable { services.geoclue2.enable = true; };
}
