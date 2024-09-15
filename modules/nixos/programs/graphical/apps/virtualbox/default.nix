{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.virtualbox;
in
{
  options.${namespace}.programs.graphical.apps.virtualbox = {
    enable = mkEnableOption "VirtualBox";
  };

  config = mkIf cfg.enable {
    ${namespace}.user.extraGroups = [ "vboxusers" ];

    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
}
