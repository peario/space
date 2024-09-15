{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.fingerprint;
in
{
  options.${namespace}.hardware.fingerprint = {
    enable = mkEnableOption "Fingerprint support";
  };

  config = mkIf cfg.enable { services.fprintd.enable = true; };
}
