{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.editors.emacs;
in
{
  options.${namespace}.programs.terminal.editors.emacs = {
    enable = mkEnableOption "emacs";
    default = {
      editor = mkEnableOption "Set emacs as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set emacs as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = mkIf cfg.default.editor "emacs";
        VISUAL = mkIf cfg.default.visual "emacs";
      };
    };
  };
}
