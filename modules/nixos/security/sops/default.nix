{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.security.sops;
in
{
  options.${namespace}.security.sops = with types; {
    enable = mkEnableOption "sops";
    defaultSopsFile = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ "/etc/ssh/ssh_host_ed25519_key" ] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        inherit (cfg) sshKeyPaths;

        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };
    };

    # NOTE: Assign values once a linux system is setup
    # sops.secrets = {
    #   "git/ssh-key" = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/magnetar/peario/default.yaml";
    #   };
    # };
  };
}
