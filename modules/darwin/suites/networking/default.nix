{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.networking;
in
{
  options.${namespace}.suites.networking = {
    enable = mkBoolOpt false "Enable networking configuration.";
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
