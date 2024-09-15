{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.vm;
in
{
  options.${namespace}.suites.vm = {
    enable = mkEnableOption "VM suite";
  };

  config = mkIf cfg.enable {
    space = {
      services = {
        spice-vdagentd = enabled;
        spice-webdav = enabled;
      };
    };
  };
}
