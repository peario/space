{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.lazygit;
in
{
  options.${namespace}.programs.terminal.tools.lazygit = {
    enable = mkEnableOption "lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;

      settings = {
        gui = {
          authorColors = {
            "${config.${namespace}.user.fullName}" = "#c6a0f6";
            "dependabot[bot]" = "#eed49f";
          };
          branchColors = {
            main = "#ed8796";
            master = "#ed8796";
            dev = "#8bd5ca";
          };
        };
        git = {
          overrideGpg = true;
        };
      };
    };

    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
