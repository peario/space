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

  cfg = config.${namespace}.suites.video;
in
{
  options.${namespace}.suites.video = {
    enable = mkEnableOption "Video suite";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals stdenv.isLinux [
        celluloid
        devede
        # handbrake
        mediainfo-gui
        shotcut
        vlc
      ]
      ++ lib.optionals stdenv.isDarwin [ iina ];

    space = {
      programs = {
        graphical.apps = {
          obs = enabled;
          mpv = enabled;
        };
      };
    };
  };
}
