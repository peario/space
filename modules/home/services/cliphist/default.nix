{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.${namespace}.services.cliphist;
in
{
  options.${namespace}.services.cliphist = {
    enable = mkEnableOption "cliphist";

    systemdTargets = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Systemd targets for cliphist
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      cliphist = {
        enable = true;
        allowImages = true;
      };
    };

    systemd.user.services = {
      cliphist.Install.WantedBy = cfg.systemdTargets;
      cliphist-images.Install.WantedBy = cfg.systemdTargets;
    };
  };
}
