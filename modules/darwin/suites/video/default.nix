{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.video;
in
{
  options.${namespace}.suites.video = {
    enable = mkEnableOption "Video suite";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ ffmpeg ]; };
}
