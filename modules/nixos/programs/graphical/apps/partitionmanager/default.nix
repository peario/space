{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.partitionmanager;
in
{
  options.${namespace}.programs.graphical.apps.partitionmanager = {
    enable = mkEnableOption "partitionmanager";
  };

  config = mkIf cfg.enable {
    programs.partition-manager = {
      enable = true;
      package = pkgs.kdePackages.partitionmanager;
    };
  };
}
