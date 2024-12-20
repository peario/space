{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  sshAgentShell =
    mkIf cfg.sshAgent
      # bash
      ''
        killall ssh-agent >/dev/null 2>&1
        eval $(ssh-agent) >/dev/null
      '';

  cfg = config.${namespace}.programs.terminal.tools.ssh;
in
# FIX(ssh): Find out what key should be here instead
# default-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAZIwy7nkz8CZYR/ZTSNr+7lRBW2AYy1jw06b44zaID";
#
# other-hosts = lib.filterAttrs (
#   key: host: key != name && (host.config.${namespace}.user.name or null) != null
# ) ((inputs.self.nixosConfigurations or { }) // (inputs.self.darwinConfigurations or { }));
#
# other-hosts-config = lib.concatMapStringsSep "\n" (
#   name:
#   let
#     remote = other-hosts.${name};
#     remote-user-name = remote.config.${namespace}.user.name;
#     remote-user-id = builtins.toString remote.config.users.users.${remote-user-name}.uid;
#
#     forward-gpg =
#       optionalString (config.services.gpg-agent.enable && remote.config.services.gpg-agent.enable)
#         ''
#           RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent /run/user/${user-id}/gnupg/S.gpg-agent.extra
#           RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent.ssh /run/user/${user-id}/gnupg/S.gpg-agent.ssh
#         '';
#     port-expr =
#       if builtins.hasAttr name inputs.self.nixosConfigurations then
#         "Port ${builtins.toString cfg.port}"
#       else
#         "";
#   in
#   "Host ${name}\n  Hostname ${name}.local\n  User ${remote-user-name}\n  ForwardAgent yes\n  ${port-expr}\n  ${forward-gpg}"
# ) (builtins.attrNames other-hosts);
{
  options.${namespace}.programs.terminal.tools.ssh = with types; {
    enable = mkEnableOption "SSH";
    authorizedKeys = mkOpt (listOf str) [
      # default-key
    ] "The public keys to apply.";
    extraConfig = mkOpt str "" "Extra configuration to apply.";
    port = mkOpt port 2222 "The port to listen on (in addition to 22).";
    sshAgent = mkEnableOption "Start the ssh agent, also stops the old agent if running.";
  };

  config = mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;

        extraConfig = "${cfg.extraConfig}";
      };

      bash.initExtra = sshAgentShell;
      fish.shellInit = sshAgentShell;
      zsh.initExtra = sshAgentShell;
    };

    # home = {
    #   shellAliases = foldl (
    #     aliases: system: aliases // { "ssh-${system}" = "ssh ${system} -t tmux a"; }
    #   ) { } (builtins.attrNames other-hosts);
    #
    #   file = mkIf pkgs.stdenv.isDarwin {
    #     ".ssh/authorized_keys".text = builtins.concatStringsSep "\n" cfg.authorizedKeys;
    #   };
    # };
  };
}
