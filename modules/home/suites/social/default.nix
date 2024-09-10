{ config, lib, namespace, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.social;
in {
  options.${namespace}.suites.social = {
    enable = mkBoolOpt false "Enable social configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs;
      [
        # caprine-bin
        # element-desktop
        # slack
        # telegram-desktop
      ]);

    space = {
      programs = {
        graphical.apps = {
          discord = enabled;
          # caprine = enabled;
        };

        terminal.social = {
          # slack-term = enabled;
          twitch-tui = enabled;
        };
      };
    };
  };
}
