{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.graphical.apps._1password;
in
{
  options.${namespace}.programs.graphical.apps._1password = {
    enable = mkEnableOption "1Password";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password = enabled;
      _1password-gui = {
        enable = true;
        package = pkgs._1password-gui;

        polkitPolicyOwners = [ config.${namespace}.user.name ];
      };

      ssh.extraConfig = ''
        Host *
          AddKeysToAgent yes
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
