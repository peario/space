{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.bluetooth;
in
{
  options.${namespace}.hardware.bluetooth = {
    enable = mkEnableOption "Support for extra Bluetooth devices";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;

      package = pkgs.bluez-experimental;
      powerOnBoot = true;

      settings = {
        General = {
          Experimental = true;
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    boot.kernelParams = [ "btusb" ];

    services.blueman = {
      enable = true;
    };
  };
}
