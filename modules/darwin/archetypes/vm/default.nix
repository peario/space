{ config, lib, namespace, ... }:
let
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.archetypes.vm;
in {
  options.${namespace}.archetypes.vm = {
    enable = mkBoolOpt false "Enable the vm archetype.";
  };

  config = lib.mkIf cfg.enable {
    space = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        vm = enabled;
      };
    };
  };
}
