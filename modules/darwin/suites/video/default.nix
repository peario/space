{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.video;
in
{
  options.${namespace}.suites.video = {
    enable = mkBoolOpt false "Enable video configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ffmpeg ];

    homebrew = {
      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Infuse" = 1136220934;
        "iMovie" = 408981434;
      };
    };
  };
}
