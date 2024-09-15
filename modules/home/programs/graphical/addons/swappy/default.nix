{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.addons.swappy;
in
{
  options.${namespace}.programs.graphical.addons.swappy = {
    enable = mkEnableOption "Swappy (desktop env)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ swappy ];

    home.file."Pictures/screenshots/.keep".text = "";
    xdg.configFile."swappy/config".source = ./config;
  };
}
