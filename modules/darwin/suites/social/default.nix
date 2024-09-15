{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.social;
in
{
  options.${namespace}.suites.social = {
    enable = mkEnableOption "Social suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ ];
    };
  };
}
