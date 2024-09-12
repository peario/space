{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.social.twitch-tui;
in
{
  options.${namespace}.programs.terminal.social.twitch-tui = {
    enable = mkBoolOpt false "Enable twitch-tui.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.twitch-tui ];

    # sops.secrets = {
    #   twitch-tui = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
    #     path = "${config.home.homeDirectory}/.config/twt/config.toml";
    #   };
    # };
  };
}
