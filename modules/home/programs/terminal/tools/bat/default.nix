{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  batVariables = {
    BAT_THEME_DARK = "OneNord";
    BAT_THEME_LIGHT = "OneNord";
  };

  cfg = config.${namespace}.programs.terminal.tools.bat;
in
{
  options.${namespace}.programs.terminal.tools.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;

        # config = {
        #   style = "auto,header-filesize";
        # };

        extraPackages = with pkgs.bat-extras; [
          # batdiff
          batgrep
          batman
          # batpipe
          # batwatch
          prettybat
        ];
      };

      zsh.sessionVariables = batVariables;
      bash.sessionVariables = batVariables;
    };

    home.shellAliases = {
      cat = "${getExe pkgs.bat} --style=plain --color=always";
    };

    xdg.configFile = {
      bat = {
        enable = true;
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/bat";
        target = "bat";
      };
    };
  };
}
