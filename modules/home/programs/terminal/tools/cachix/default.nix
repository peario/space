{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.cachix;
in
{
  options.${namespace}.programs.terminal.tools.cachix = {
    enable = mkEnableOption "Enable Cachix.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ cachix ];

    programs = {
      bash.initExtra = # bash
        ''
          export CACHIX_AUTH_TOKEN="$(cat ${config.sops.secrets."cachix/cache".path})"
          export CACHIX_AGENT_TOKEN="$(cat ${config.sops.secrets."cachix/agent".path})"
        '';
      fish.shellInit = # fish
        ''
          export CACHIX_AUTH_TOKEN="(cat ${config.sops.secrets."cachix/cache".path})"
          export CACHIX_AGENT_TOKEN="(cat ${config.sops.secrets."cachix/agent".path})"
        '';
      zsh.initExtra = # bash
        ''
          export CACHIX_AUTH_TOKEN="$(cat ${config.sops.secrets."cachix/cache".path})"
          export CACHIX_AGENT_TOKEN="$(cat ${config.sops.secrets."cachix/agent".path})"
        '';
    };

    sops.secrets = {
      "cachix/cache" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
      };
      "cachix/agent" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
      };
    };
  };
}
