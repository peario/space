{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = {
    enable = mkEnableOption "common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      coreutils
      curl
      dt
      fd
      file
      findutils
      fswatch
      gdu
      killall
      lsof
      pciutils
      pkgs.${namespace}.ikill
      tldr
      unzip
      wget
      xclip
    ];
  };
}
