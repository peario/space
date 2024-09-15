{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  cfg = config.${namespace}.archetypes.wsl;
in
{
  options.${namespace}.archetypes.wsl = {
    enable = mkEnableOption "WSL archetype";
  };

  config = mkIf cfg.enable {
    environment = {
      noXlibs = mkForce false;

      sessionVariables = {
        BROWSER = "wsl-open";
      };

      systemPackages = with pkgs; [
        dos2unix
        wsl-open
        wslu
      ];
    };
  };
}
