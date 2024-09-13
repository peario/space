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

  cfg = config.${namespace}.programs.terminal.tools.wine;
in
{
  options.${namespace}.programs.terminal.tools.wine = {
    enable = mkBoolOpt false "Enable Wine.";
  };

  config = mkIf cfg.enable {
    # TODO(wine): Check if Wine is linux-only. If so, do an if-check so that macOS won't install.
    home.packages = with pkgs; [
      # winePackages.waylandFull
      winetricks
      wine64Packages.waylandFull
    ];
  };
}
