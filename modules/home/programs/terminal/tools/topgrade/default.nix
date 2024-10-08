{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.topgrade;
in
{
  # TODO(topgrade): Figure out what this is.
  options.${namespace}.programs.terminal.tools.topgrade = {
    enable = mkEnableOption "topgrade";
  };

  config = mkIf cfg.enable {
    programs.topgrade = {
      enable = true;

      settings = {
        misc = {
          no_retry = true;
          display_time = true;
          skip_notify = true;
        };
        git = {
          repos = [
            "~/Documents/github/*/"
            "~/Documents/gitlab/*/"
            "~/.config/.dotfiles/"
            "~/.config/nvim/"
          ];
        };
      };
    };
  };
}
