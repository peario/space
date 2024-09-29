{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.rgb.openrgb;
in
{
  options.${namespace}.hardware.rgb.openrgb = with types; {
    enable = mkEnableOption "Support for rgb controls";
    motherboard = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
        ]
      );
      default = "amd";
      description = "CPU family of motherboard. Allows for addition motherboard i2c support.";
    };
    openRGBConfig = mkOpt (nullOr path) null "The openrgb file to create.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i2c-tools
      openrgb-with-all-plugins
    ];

    ${namespace}.home.configFile =
      { }
      // lib.optionalAttrs (cfg.openRGBConfig != null) {
        "OpenRGB/sizes.ors".source = cfg.openRGBConfig + "/sizes.ors";
        "OpenRGB/Default.orp".source = cfg.openRGBConfig + "/Default.orp";
      };

    services.hardware.openrgb = {
      enable = true;
      inherit (cfg) motherboard;
    };
  };
}
