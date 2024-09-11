{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

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

  cfg = config.${namespace}.programs.graphical.apps._1password;
in
{
  options.${namespace}.programs.graphical.apps._1password = {
    enable = mkBoolOpt false "Enable 1password.";
  };

  config = mkIf cfg.enable {
    programs = {
      ssh.extraConfig = ''
        Host *.github.com
          AddKeysToAgent yes
          ForwardAgent yes
          IdentityAgent "${identityAgent}"
      '';
    };

    xdg.configFile = mkIf pkgs.stdenv.isLinux {
      ".config/1Password/ssh/agent.toml".text = _1PasswordAgentConf;
    };

    home.file = mkIf pkgs.stdenv.isDarwin {
      ".config/1Password/ssh/agent.toml".text = _1PasswordAgentConf;
    };
  };
}
