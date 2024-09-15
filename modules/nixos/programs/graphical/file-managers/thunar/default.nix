{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.file-managers.thunar;
in
{
  options.${namespace}.programs.graphical.file-managers.thunar = {
    enable = mkEnableOption "XFCE file manager";
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
    };
  };
}
