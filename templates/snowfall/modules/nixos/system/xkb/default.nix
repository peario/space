{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.xkb;
in {
  options.${namespace}.system.xkb = {
    enable = mkBoolOpt false "Whether or not to configure xkb.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver = {
      xkb = {
        # TODO(xkb): Doublecheck that `se` is the layout for Swedish (sv-latin1)
        layout = "se";
        options = "caps:escape";
      };
    };
  };
}
