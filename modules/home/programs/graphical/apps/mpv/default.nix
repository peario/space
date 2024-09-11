{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.mpv;

in
{
  options.${namespace}.programs.graphical.apps.mpv = {
    enable = mkEnableOption "Support for mpv";
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;

      defaultProfiles = [ "gpu-hq" ];
      scripts = lib.optionals pkgs.stdenv.isLinux [ pkgs.mpvScripts.mpris ];
    };

    services.plex-mpv-shim.enable = pkgs.stdenv.isLinux;
  };
}
