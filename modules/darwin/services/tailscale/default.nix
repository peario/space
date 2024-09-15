{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.tailscale;
in
{
  options.${namespace}.services.tailscale = {
    enable = mkBoolOpt true "Enable Tailscale.";
  };

  config = mkIf cfg.enable {
    services = {
      tailscale = {
        enable = true;
        package = pkgs.tailscale;
      };
    };
  };
}
