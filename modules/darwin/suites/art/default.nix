{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.art;
in
{
  options.${namespace}.suites.art = {
    enable = mkEnableOption "Art suite";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      imagemagick
      pngcheck
    ];

    homebrew = {
      casks = [
        "blender"
        "figma"
        "gimp"
        "inkscape"
        "mediainfo"
      ];
    };
  };
}
