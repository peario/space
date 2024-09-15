{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.printing;
in
{
  options.${namespace}.services.printing = {
    enable = mkEnableOption "Printing support";
  };

  config = mkIf cfg.enable {
    services = {
      colord.enable = true;

      printing = {
        enable = true;
        browsing = true;

        drivers = with pkgs; [ brlaser ];

        extraConf = ''
          LogLevel warn
          PageLogFormat

          # Specifies the maximum size of the log files before they are rotated.  The value "0" disables log rotation.
          MaxLogSize 0

          # Default error policy for printers
          ErrorPolicy retry-job

          # Show shared printers on the local network.
          BrowseLocalProtocols dnssd

          # Default authentication type, when authentication is required...
          DefaultAuthType Basic

          # Timeout after cupsd exits if idle (applied only if cupsd runs on-demand - with -l)
          IdleExitTimeout 60
        '';
      };
    };
  };
}
