{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.video;
in
{
  options.${namespace}.suites.video = {
    enable = mkBoolOpt false "Enable video configuration.";
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
          spicetify = enabled;
        };
      };
    };
  };
}
