{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.keyring;
in
{
  options.${namespace}.services.keyring = {
    enable = mkEnableOption "Gnome keyring";
  };

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;

      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
