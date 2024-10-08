{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.xkb;
in
{
  options.${namespace}.system.xkb = {
    enable = mkEnableOption "Configure XKB";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver = {
      xkb = {
        # Default is "us" for english.
        #  For swedish use "se"
        layout = "se";
        model = "pc105";
        options = "caps:escape";
      };
    };
  };
}
