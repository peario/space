{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.security.keyring;
in
{
  options.${namespace}.security.keyring = {
    enable = mkEnableOption "Gnome keyring";
  };

  config = mkIf cfg.enable { services.gnome.gnome-keyring.enable = true; };
}
