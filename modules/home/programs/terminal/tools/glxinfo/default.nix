{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.glxinfo;
in
{
  options.${namespace}.programs.terminal.tools.glxinfo = {
    enable = mkEnableOption "glxinfo";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ glxinfo ]; };
}
