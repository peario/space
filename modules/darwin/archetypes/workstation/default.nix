{ config, lib, namespace, ... }:
let
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.archetypes.workstation;
in {
  options.${namespace}.archetypes.workstation = {
    enable = mkBoolOpt false "Enable the workstation archetype.";
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
