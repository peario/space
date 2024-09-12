{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.music;
in
{
  options.${namespace}.suites.music = {
    enable = mkBoolOpt false "Enable music configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cumulus" # Soundcloud
        "spotify"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable { "GarageBand" = 682658836; };
    };
  };
}
