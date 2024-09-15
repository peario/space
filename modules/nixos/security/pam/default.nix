{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.security.pam;
in
{
  options.${namespace}.security.pam = {
    enable = mkEnableOption "Configure PAM";
  };

  config = mkIf cfg.enable {
    security.pam.loginLimits = [
      {
        domain = "*";
        item = "nofile";
        type = "-";
        value = "65536";
      }
    ];
  };
}
