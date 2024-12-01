{
  config,
  lib,
  pkgs,
  namespace,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption optionalString;

  tokenExports =
    optionalString osConfig.${namespace}.security.sops.enable # Bash
      ''
        if [ -f ${config.sops.secrets."cachix/cache".path} ]; then
          CACHIX_AUTH_TOKEN="$(cat ${config.sops.secrets."cachix/cache".path})"
          export CACHIX_AUTH_TOKEN
        fi

        if [ -f ${config.sops.secrets."cachix/agent".path} ]; then
          CACHIX_AGENT_TOKEN="$(cat ${config.sops.secrets."cachix/agent".path})"
          export CACHIX_AGENT_TOKEN
        fi
      '';

  cfg = config.${namespace}.programs.terminal.tools.cachix;
in
{
  options.${namespace}.programs.terminal.tools.cachix = {
    enable = mkEnableOption "Cachix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ cachix ];

    programs = {
      bash.initExtra = tokenExports;
      fish.shellInit = tokenExports;
      zsh.initExtra = tokenExports;
    };

    sops.secrets = mkIf osConfig.${namespace}.security.sops.enable {
      "cachix/cache" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/peario/default.yaml";
      };
      "cachix/agent" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/peario/default.yaml";
      };
    };
  };
}
