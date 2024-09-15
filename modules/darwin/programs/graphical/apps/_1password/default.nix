{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps._1password;
in
{
  options.${namespace}.programs.graphical.apps._1password = {
    enable = mkEnableOption "1Password";
  };

  config = mkIf cfg.enable {
    homebrew = {
      taps = [ "1password/tap" ];

      casks = [
        "1password"
        "1password-cli"
      ];

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "1Password for Safari" = 1569813296;
      };
    };

    environment.variables = {
      SSH_AUTH_SOCK = mkIf pkgs.stdenv.isDarwin "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };
  };
}
