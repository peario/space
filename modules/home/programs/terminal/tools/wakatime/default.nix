{
  config,
  lib,
  namespace,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;

  cfg = config.${namespace}.programs.terminal.tools.wakatime;
in
{
  options.${namespace}.programs.terminal.tools.wakatime = {
    enable = mkEnableOption "WakaTime";
    additionalConfig = mkOption {
      type = types.lines;
      default = ''
        debug = false
        hidefilenames = false
        ignore =
          COMMIT_EDITMSG$
          PULLREQ_EDITMSG$
          MERGE_MSG$
          TAG_EDITMSG$
      '';
      description = "Additional Wakatime configuration options";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wakatime-cli ];

    programs = {
      zsh = {
        initExtra = ''
          if [ -f "${config.sops.secrets."wakatime/key".path}" ]; then
            apiKey=$(cat "${config.sops.secrets."wakatime/key".path}")
            cat > "${config.home.homeDirectory}/.wakatime.cfg" <<EOF
          [settings]
          api_key = $apiKey
          ${cfg.additionalConfig}
          EOF
          else
            echo "WakaTime key file not found!" >&2
            # Don't exit in `.zshrc`!
            # exit 1
          fi
        '';
      };
    };

    sops.secrets = mkIf osConfig.${namespace}.security.sops.enable {
      "wakatime/key" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/peario/default.yaml";
      };
    };
  };
}
