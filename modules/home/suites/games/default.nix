{
  config,
  lib,
  pkgs,
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
    home.packages = with pkgs; [
      bottles
      heroic
      lutris
      prismlauncher
      proton-caller
      protontricks
      protonup-ng
      protonup-qt
    ];

    space = {
      programs = {
        terminal = {
          tools = {
            wine = enabled;
          };
        };
      };
    };
  };
}
