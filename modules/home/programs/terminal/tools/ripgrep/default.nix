{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    getExe
    ;

  cfg = config.${namespace}.programs.terminal.tools.ripgrep;
in
{
  # TODO(ripgrep): Check if settings needs to be adjusted
  options.${namespace}.programs.terminal.tools.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep;

      arguments = [
        # Don't have ripgrep vomit a bunch of stuff on the screen
        # show a preview of the match
        "--max-columns=150"
        "--max-columns-preview"

        # ignore git files
        "--glob=!.git/*"

        "--smart-case"
      ];
    };

    home.shellAliases = {
      grep = mkForce (getExe config.programs.ripgrep.package);
    };
  };
}
