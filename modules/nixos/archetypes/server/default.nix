{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.server;
in
{
  options.${namespace}.archetypes.server = {
    enable = mkEnableOption "Server archetype";
  };

  config = mkIf cfg.enable {
    space = {
      suites = {
        common = enabled;
      };
    };
  };
}
