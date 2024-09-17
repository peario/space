{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.theme.gtk;
in
{
  options.${namespace}.theme.gtk = with types; {
    enable = mkEnableOption "Customize GTK and apply themes";

    theme = {
      name = mkOpt str "catppuccin-macchiato-blue-standard" "The name of the GTK theme to apply.";
      package = mkOpt package (pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "macchiato";
      }) "The package to use for the theme.";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables = {
        GTK_THEME = cfg.theme.name;
      };
    };

    services = {
      # needed for GNOME services outside of GNOME Desktop
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };
  };
}