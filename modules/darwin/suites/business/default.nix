{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.business;
in
{
  options.${namespace}.suites.business = {
    enable = mkEnableOption "Business suite";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        # TODO: Gradual removal of bitwarden
        # "bitwarden"
        "calibre"
        "microsoft-office"
        "microsoft-teams"
        "obsidian"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Keynote" = 409183694;
        "Numbers" = 409203825;
        "Pages" = 409201541;
      };
    };

    space = {
      programs = {
        graphical = {
          apps = {
            _1password = enabled;
          };
        };
      };
    };
  };
}
