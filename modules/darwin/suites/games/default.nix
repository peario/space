{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.games;
in
{
  options.${namespace}.suites.games = {
    enable = mkEnableOption "Games suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "moonlight" ];
    };
  };
}
