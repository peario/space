{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.workstation;
in
{
  options.${namespace}.archetypes.workstation = {
    enable = mkEnableOption "Workstation archetype";
  };

  config = lib.mkIf cfg.enable {
    space = {
      # TODO: input-leap replace barrier

      suites = {
        business = enabled;
        common = enabled;
        desktop = enabled;
        development = enabled;
      };
    };
  };
}
