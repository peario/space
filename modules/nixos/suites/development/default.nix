{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "Development suite";
    azure.enable = mkEnableOption "Azure development suite";
    docker.enable = mkEnableOption "Docker development suite";
    game.enable = mkEnableOption "Game development suite";
    kubernetes.enable = mkEnableOption "Kubernetes development suite";
    nix.enable = mkEnableOption "Nix development suite";
    sql.enable = mkEnableOption "SQL development suite";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      12345
      3000
      3001
      8080
      8081
    ];

    space = {
      user = {
        extraGroups = [ "git" ] ++ lib.optionals cfg.sql.enable [ "mysql" ];
      };

      virtualisation = {
        podman.enable = cfg.docker.enable;
      };
    };
  };
}
