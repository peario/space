{
  config,
  lib,
  pkgs,
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
    home.packages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        appimage-run
        bitwarden
        bleachbit
        clac
        dropbox
        dupeguru
        feh
        filelight
        fontpreview
        gparted
        input-leap
        kdePackages.ark
        kdePackages.gwenview
        # pkgs.${namespace}.pocketcasts
        realvnc-vnc-viewer
        # FIXME: broken nixpkgs
        # rustdesk
      ];
  };
}
