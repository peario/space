{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption literalExpression;

  cfg = config.${namespace}.programs.graphical.mangohud;
in
{
  options.${namespace}.programs.graphical.mangohud = {
    enable = mkEnableOption "MangoHud";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      package = pkgs.mangohud;
      enableSessionWide = true;
      settings = literalExpression ''
        {
          output_folder = ~/Documents/mangohud/;
          full = true;
        }
      '';
    };
  };
}
