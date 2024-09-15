{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.vm;
in
{
  options.${namespace}.archetypes.vm = {
    enable = mkEnableOption "VM archetype";
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
