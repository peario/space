{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.art;
in {
  options.${namespace}.suites.art = {
    enable = mkBoolOpt false "Enable art configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ blender gimp inkscape-with-extensions ];
  };
}
