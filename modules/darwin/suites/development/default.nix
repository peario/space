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
        "electron"
        "powershell"
        "visual-studio-code"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable { "Xcode" = 497799835; };
    };
  };
}
