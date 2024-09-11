{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.wlroots;
in
{
  options.${namespace}.suites.wlroots = {
    enable = mkBoolOpt false "Enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wdisplays
      wl-clipboard
      wlr-randr
      wl-screenrec
    ];

    space = {
      programs = {
        graphical = {
          addons = {
            electron-support = enabled;
            swappy = enabled;
            swaync = enabled;
            wlogout = enabled;
          };

          bars = {
            waybar = enabled;
          };
        };
      };

      services = {
        cliphist = enabled;
        keyring = enabled;
      };
    };

    # using nixos module
    # services.network-manager-applet.enable = true;
    services = {
      blueman-applet.enable = true;
    };
  };
}
