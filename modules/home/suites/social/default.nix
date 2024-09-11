{
  config,
  lib,
  namespace,
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

    space = {
      programs = {
        graphical.apps = {
          discord = enabled;
        };

        terminal.social = {
          # slack-term = enabled;
          # twitch-tui = enabled;
        };
      };
    };
  };
}
