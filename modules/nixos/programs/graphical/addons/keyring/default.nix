{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.addons.keyring;
in
{
  options.${namespace}.programs.graphical.addons.keyring = {
    enable = mkEnableOption "Passwords application";
  };

  config = mkIf cfg.enable { programs.seahorse.enable = true; };
}
