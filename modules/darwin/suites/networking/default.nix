{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.networking;
in
{
  options.${namespace}.suites.networking = {
    enable = mkEnableOption "Networking suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        # TODO(vpn): See https://github.com/phirecc/wgnord, a Linux version of NordVPN?
        "nordvpn"
      ];
    };

    space = {
      services = {
        tailscale = enabled;
      };

      system = {
        networking = enabled;
      };
    };
  };
}
