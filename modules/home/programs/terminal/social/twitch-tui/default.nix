{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.social.twitch-tui;
in
{
  options.${namespace}.programs.terminal.social.twitch-tui = {
    enable = mkEnableOption "twitch-tui";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.twitch-tui ];

    # sops.secrets = {
    #   twitch-tui = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
    #     path = "${config.home.homeDirectory}/.config/twt/config.toml";
    #   };
    # };
  };
}
