{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.opengl;
in
{
  options.${namespace}.hardware.opengl = {
    enable = mkEnableOption "Support for opengl";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libva-utils
      vdpauinfo
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        libva
        libvdpau
        libdrm
      ];
    };
  };
}
