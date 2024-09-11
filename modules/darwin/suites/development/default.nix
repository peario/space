{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Enable common development configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cutter"
        "docker"
        "electron"
        "powershell"
        "visual-studio-code"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Patterns" = 429449079;
        "Xcode" = 497799835;
      };
    };
  };
}
