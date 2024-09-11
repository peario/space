{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.retroarch;
in
{
  options.${namespace}.programs.graphical.apps.retroarch = {
    enable = mkEnableOption "RetroArch";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (retroarch.override {
        cores = with libretro; [
          beetle-psx-hw
          bsnes
          citra
          dolphin
          dosbox
          genesis-plus-gx
          mame
          mgba
          nestopia
          pcsx2
          snes9x
        ];
      })
    ];
  };
}
