{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.services.nix-daemon;
in
{
  options.${namespace}.services.nix-daemon = {
    enable = mkBoolOpt true "Enable the Nix daemon.";
  };

  config = mkIf cfg.enable { services.nix-daemon = enabled; };
}
