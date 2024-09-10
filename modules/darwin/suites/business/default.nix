{ config, lib, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.business;
in {
  options.${namespace}.suites.business = {
    enable = mkBoolOpt false "Enable business configuration.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "bitwarden"
        "calibre"
        "libreoffice"
        "meetingbar"
        "obsidian"
        "thunderbird"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Brother iPrint&Scan" = 1193539993;
        "Keynote" = 409183694;
        "Microsoft OneNote" = 784801555;
        "Notability" = 360593530;
        "Numbers" = 409203825;
        "Pages" = 409201541;
      };
    };

    space = {
      programs = { graphical = { apps = { _1password = enabled; }; }; };
    };
  };
}
