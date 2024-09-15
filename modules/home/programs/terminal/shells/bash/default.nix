{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.shell.bash;
in
{
  options.${namespace}.programs.terminal.shell.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      initExtra = # bash
        ''
          # Hide "Last Login: ..." message in new terminal/session
          [ ! -f ~/.hushlogin ] && touch ~/.hushlogin

          bunnyfetch
        '';
    };
  };
}
