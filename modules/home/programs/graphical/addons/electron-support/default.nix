{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.addons.electron-support;
in
{
  options.${namespace}.programs.graphical.addons.electron-support = {
    enable = mkEnableOption "Wayland Electron support (desktop env)";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."electron-flags.conf".source = ./electron-flags.conf;
  };
}
