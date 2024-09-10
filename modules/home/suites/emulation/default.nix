{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.emulation;
in {
  options.${namespace}.suites.emulation = {
    enable = mkBoolOpt false "Enable emulation configuration.";
    retroarchFull = mkBoolOpt false "Enable emulation configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ mame mednafen melonDS pcsx2 snes9x ] ++ lib.optionals stdenv.isLinux [
        cemu
        duckstation
        emulationstation
        mgba
        mupen64plus
        nestopia-ue
        rpcs3
        ryujinx
        xemu
      ] ++ lib.optionals cfg.retroarchFull [ retroarchFull ];

    space = {
      programs = {
        graphical = {
          apps = {
            retroarch.enable = if cfg.retroarchFull then false else true;
          };
        };
      };
    };
  };
}
