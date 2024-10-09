{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = {
    enable = mkEnableOption "Desktop suite";
  };

  config = mkIf cfg.enable {
    # TODO: Before (and if) enabling these desktop configs, measure performance
    # ${namespace}.desktop = {
    #   addons = {
    #     skhd = enabled;
    #     jankyborders = enabled;
    #   };
    #
    #   bars = {
    #     sketchybar = enabled;
    #   };
    #
    #   wms = {
    #     yabai = enabled;
    #   };
    # };

    homebrew = {
      brews = [
        "blueutil"
        "ifstat"
        "switchaudio-osx"
      ];

      casks = [
        "alt-tab"
        "appcleaner"
        "bartender"
        "brave-browser"
        "firefox@developer-edition"
        "gpg-suite"
        "launchcontrol"
        "monitorcontrol"
        "raycast"
        "rectangle"
        "sf-symbols"
      ];

      taps = [
        "beeftornado/rmtree"
        "bramstein/webfonttools"
        "felixkratz/homebrew-formulae"
        "khanhas/tap"
        "teamookla/speedtest"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Amphetamine" = 937984704;
        "AutoMounter" = 1160435653;
        "Disk Speed Test" = 425264550;
        "PopClip" = 445189367;
        "TestFlight" = 899247664;
        "WiFi Explorer" = 494803304;
      };
    };
  };
}
