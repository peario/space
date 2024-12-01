{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.social.slack-term;
in
{
  options.${namespace}.programs.terminal.social.slack-term = {
    enable = mkEnableOption "slack-term";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.slack-term ];

    # sops.secrets = {
    #   slack-term = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/peario/default.yaml";
    #     path = "${config.home.homeDirectory}/.config/slack-term/config";
    #   };
    # };
  };
}
