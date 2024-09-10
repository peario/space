{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.music;
in {
  options.${namespace}.suites.music = {
    enable = mkBoolOpt false "Enable common music configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ musikcube pulsemixer ] ++ lib.optionals pkgs.stdenv.isLinux [
        ardour
        mpd-notification
        mpdevil
        spicetify-cli
        tageditor
        youtube-music
        pkgs.${namespace}.yt-music
      ];

    space = {
      programs.terminal = {
        media = {
          ncmpcpp = enabled;
          ncspot = enabled;
        };

        tools = { cava = enabled; };
      };

      services = { mpd = mkIf pkgs.stdenv.isLinux enabled; };
    };
  };
}
