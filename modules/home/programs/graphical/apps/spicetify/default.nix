{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (inputs) spicetify-nix;

  cfg = config.${namespace}.programs.graphical.apps.spicetify;

  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.${namespace}.programs.graphical.apps.spicetify = {
    enable = mkEnableOption "Support for Spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;

      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        marketplace
        reddit
      ];

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        autoSkip
        fullAppDisplay
        history
        playNext
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        volumePercentage
      ];
    };
  };
}
