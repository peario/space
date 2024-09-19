{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.games;
in
{
  options.${namespace}.suites.games = {
    enable = mkEnableOption "Games suite";
  };

  config = mkIf cfg.enable {
    space = {
      programs = {
        graphical = {
          addons = {
            gamemode = enabled;
            gamescope = enabled;
            # mangohud = enabled;
          };

          apps = {
            steam = enabled;
          };
        };
      };
    };
  };
}
