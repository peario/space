{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.steam;
in
{
  options.${namespace}.programs.graphical.apps.steam = {
    enable = mkEnableOption "Support for Steam";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ steamtinkerlaunch ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [ pkgs.proton-ge-bin.steamcompattool ];
    };

    hardware.steam-hardware.enable = true;
  };
}
