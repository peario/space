{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.cloudflared;
in
{
  options.${namespace}.services.cloudflared = {
    enable = mkEnableOption "Cloudflared";
  };

  config = mkIf cfg.enable {
    # NOTE: future reference for adding assertions
    # assertions = [
    #   {
    #     assertion = cfg.autoconnect.enable -> cfg.autoconnect.key != "";
    #     message = "${namespace}.services.cloudflared.autoconnect.key must be set";
    #   }
    # ];

    services.cloudflared = {
      enable = true;
      package = pkgs.cloudflared;

      tunnels = { };
    };
  };
}
