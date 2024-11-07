{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  identityAgent =
    if pkgs.stdenv.isLinux then
      "~/.1password/agent.sock"
    else
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  _1PasswordAgentConf = # conf
    ''
      [[ssh-keys]]
      vault = "Development"
    '';

  cfg = config.${namespace}.programs.terminal.tools._1password-cli;
in
{
  options.${namespace}.programs.terminal.tools._1password-cli = {
    enable = mkEnableOption "1Password CLI";
    sshSocket.enable = mkEnableOption "ssh-agent socket for 1Password";
  };

  config = mkIf cfg.enable {
    programs = {
      ssh.extraConfig = ''
        Host *.github.com
          AddKeysToAgent yes
          ForwardAgent yes
          ${lib.optionalString cfg.sshSocket.enable "IdentityAgent ${identityAgent}"}
      '';
    };

    xdg.configFile = {
      "1Password/ssh/agent.toml".text = _1PasswordAgentConf;
    };
  };
}
