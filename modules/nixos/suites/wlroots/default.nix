{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.wlroots;
in
{
  options.${namespace}.suites.wlroots = {
    enable = mkEnableOption "Wlroots suite";
  };

  config = mkIf cfg.enable {
    space = {
      services = {
        seatd = enabled;
      };
    };
    programs = {
      nm-applet.enable = true;
      xwayland.enable = true;

      wshowkeys = {
        enable = true;
        package = pkgs.wshowkeys;
      };
    };
  };
}
