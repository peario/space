{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;
  inherit (inputs) hyprland xdg-desktop-portal-hyprland;

  cfg = config.${namespace}.programs.graphical.addons.xdg-portal;
in
{
  options.${namespace}.programs.graphical.addons.xdg-portal = {
    enable = mkEnableOption "Support for XDG portal";
  };

  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;

        configPackages = [ hyprland.packages.${system}.hyprland ];

        config = {
          hyprland = mkIf config.${namespace}.programs.graphical.wms.hyprland.enable {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Screencast" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          };

          sway = mkIf config.${namespace}.programs.graphical.wms.sway.enable {
            default = [
              "wlr"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Screencast" = "wlr";
            "org.freedesktop.impl.portal.Screenshot" = "wlr";
          };

          common = {
            default = [ "gtk" ];

            "org.freedesktop.impl.portal.Screencast" = "gtk";
            "org.freedesktop.impl.portal.Screenshot" = "gtk";
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };

        extraPortals =
          with pkgs;
          [ xdg-desktop-portal-gtk ]
          ++ (lib.optional config.${namespace}.programs.graphical.wms.sway.enable xdg-desktop-portal-wlr)
          ++ (lib.optional config.${namespace}.programs.graphical.wms.hyprland.enable (
            xdg-desktop-portal-hyprland.packages.${system}.xdg-desktop-portal-hyprland.override {
              debug = true;
              # TODO: use same package as home-manager
              inherit (hyprland.packages.${system}) hyprland;
            }
          ));
        # xdgOpenUsePortal = true;

        wlr = {
          inherit (config.${namespace}.programs.graphical.wms.sway) enable;

          settings = {
            screencast = {
              max_fps = 30;
              chooser_type = "simple";
              chooser_cmd = "${getExe pkgs.slurp} -f %o -or";
            };
          };
        };
      };
    };
  };
}
