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

  cfg = config.${namespace}.suites.social;
in
{
  options.${namespace}.suites.social = {
    enable = mkEnableOption "Social suite";
  };

  config = mkIf cfg.enable {
    # home.packages = lib.optionals pkgs.stdenv.isLinux [
    #   # pkgs.element-desktop
    # ];

    space = {
      programs = {
        graphical.apps = {
          discord = mkIf pkgs.stdenv.isLinux enabled;
        };

        terminal.social = {
          # slack-term = enabled;
          # twitch-tui = enabled;
        };
      };
    };
  };
}
