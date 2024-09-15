{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  cfg = config.${namespace}.system.locale;
in
{
  options.${namespace}.system.locale = {
    enable = mkEnableOption "Manage locale settings";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Set locale archive variable in case it isn't being set properly
      LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
    };

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      font = "Lat2-Terminus16";
      # Default is "us" for english.
      #  For swedish use "sv"
      keyMap = mkForce "sv";
    };
  };
}
