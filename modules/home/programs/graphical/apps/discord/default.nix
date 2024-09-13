{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe mkEnableOption;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) home-manager;

  cfg = config.${namespace}.programs.graphical.apps.discord;
in
{
  options.${namespace}.programs.graphical.apps.discord = {
    enable = mkEnableOption "Enable Discord.";
    canary.enable = mkBoolOpt false "Enable Discord Canary.";
    firefox.enable = mkBoolOpt false "Enable the Firefox version of Discord.";
    betterdiscord.enable = mkBoolOpt false "Enable Better Discord.";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        lib.optional cfg.enable pkgs.discord
        ++ lib.optional cfg.canary.enable pkgs.${namespace}.discord
        ++ lib.optional cfg.firefox.enable pkgs.${namespace}.discord-firefox;

      activation = mkIf pkgs.stdenv.isLinux {
        betterdiscordInstall = # bash
          mkIf cfg.betterdiscord.enable home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            echo "Running betterdiscord install"
            ${getExe pkgs.betterdiscordctl} install || ${getExe pkgs.betterdiscordctl} reinstall || true
          '';
      };
    };
  };
}
