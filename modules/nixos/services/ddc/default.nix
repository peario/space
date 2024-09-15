{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.ddccontrol;
in
{
  options.${namespace}.services.ddccontrol = {
    enable = mkEnableOption "ddccontrol";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ddcui
      ddcutil
    ];

    services.ddccontrol = {
      enable = true;
    };
  };
}
