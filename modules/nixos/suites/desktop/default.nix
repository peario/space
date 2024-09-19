{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = {
    enable = mkEnableOption "Desktop suite";
  };

  config = mkIf cfg.enable {
    space = {
      programs = {
        graphical = {
          apps = {
            _1password = enabled;
          };

          wms = {
            hyprland = enabled;
          };
        };
      };
    };
  };
}
