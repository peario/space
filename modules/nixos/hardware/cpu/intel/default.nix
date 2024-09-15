{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.cpu.intel;
in
{
  options.${namespace}.hardware.cpu.intel = {
    enable = mkEnableOption "Support for intel CPU";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ intel-gpu-tools ];

    hardware.cpu.intel.updateMicrocode = true;

    boot = {
      kernelModules = [ "kvm-intel" ];

      kernelParams = [
        "i915.fastboot=1"
        "enable_gvt=1"
      ];
    };
  };
}
