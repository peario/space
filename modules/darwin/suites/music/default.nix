{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.music;
in
{
  options.${namespace}.suites.music = {
    enable = mkEnableOption "Music suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        # NOTE: Currently not in use
        # "cumulus" # Soundcloud
        "spotify"
      ];
    };
  };
}
