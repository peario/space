{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "Development suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cutter"
        "docker"
        "visual-studio-code"
        "jetbrains-toolbox"
      ];

      brews = [
        "mas"
        "whalebrew"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Patterns" = 429449079;
        "Xcode" = 497799835;
      };
    };
  };
}
