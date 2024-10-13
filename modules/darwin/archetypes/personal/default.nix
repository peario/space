{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.archetypes.personal;
in
{
  options.${namespace}.archetypes.personal = {
    enable = mkEnableOption "Personal archetype";
  };

  config = lib.mkIf cfg.enable {
    space = {
      suites = {
        art = enabled;
        common = enabled;
        games = {
          enable = true;
          steam = enabled;
        };
        music = enabled;
        photo = enabled;
        social = enabled;
        video = enabled;
      };
    };
  };
}
