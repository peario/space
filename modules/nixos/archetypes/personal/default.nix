{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.personal;
in
{
  options.${namespace}.archetypes.personal = {
    enable = mkEnableOption "Personal archetype";
  };

  config = mkIf cfg.enable {
    space = {
      services = {
        tailscale = enabled;
      };

      suites = {
        common = enabled;
        video = enabled;
      };
    };
  };
}
