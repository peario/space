{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.rgb.ckb-next;
in
{
  options.${namespace}.hardware.rgb.ckb-next = with types; {
    enable = mkEnableOption "Support for rgb controls";
    ckbNextConfig = mkOpt (nullOr path) null "The ckb-next.conf file to create.";
  };

  config = mkIf cfg.enable {
    hardware.ckb-next.enable = true;

    ${namespace}.home.configFile =
      { }
      // lib.optionalAttrs (cfg.ckbNextConfig != null) {
        "ckb-next/ckb-next.cfg".source = cfg.ckbNextConfig;
      };
  };
}
