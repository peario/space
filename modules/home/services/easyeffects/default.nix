{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;

  cfg = config.${namespace}.services.easyeffects;
in
{
  options.${namespace}.services.easyeffects = {
    enable = mkEnableOption "Easy Effects service";
  };

  config = lib.mkIf cfg.enable {
    services.easyeffects = {
      enable = true;

      preset = "quiet";
    };

    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
  };
}
