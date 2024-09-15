{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.emulation;
in
{
  options.${namespace}.suites.emulation = {
    enable = mkEnableOption "Emulation suite";
    retroarch.enable = mkEnableOption "RetroArch";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        mame
        mednafen
        melonDS
        pcsx2
        snes9x
      ]
      ++ lib.optionals stdenv.isLinux [
        cemu
        duckstation
        emulationstation
        mgba
        mupen64plus
        nestopia-ue
        rpcs3
        ryujinx
        xemu
      ]
      ++ lib.optionals cfg.retroarch.enable [ retroarchFull ];

    space = {
      programs = {
        graphical = {
          apps = {
            retroarch.enable = if cfg.retroarch.enable then false else true;
          };
        };
      };
    };
  };
}
