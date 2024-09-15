{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.gaming;
in
{
  options.${namespace}.archetypes.gaming = {
    enable = mkEnableOption "Gaming archetype";
  };

  config = mkIf cfg.enable {
    ${namespace}.suites = {
      common = enabled;
      desktop = enabled;
      games = enabled;
      video = enabled;
    };
  };
}
