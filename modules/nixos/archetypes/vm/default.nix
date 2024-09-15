{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.vm;
in
{
  options.${namespace}.archetypes.vm = {
    enable = mkEnableOption "VM archetype";
  };

  config = mkIf cfg.enable {
    khanelinix = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        vm = enabled;
      };
    };
  };
}
