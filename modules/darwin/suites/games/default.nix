{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption lists;

  cfg = config.${namespace}.suites.games;
in
{
  options.${namespace}.suites.games = {
    enable = mkEnableOption "Games suite";
    steam.enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "moonlight" ] ++ lists.optional cfg.steam.enable "steam";
    };
  };
}
