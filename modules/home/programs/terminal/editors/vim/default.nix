{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.${namespace}.programs.terminal.editors.vim;
in
{
  options.${namespace}.programs.terminal.editors.vim = {
    enable = mkEnableOption "vim";

    default = {
      editor = mkEnableOption "Set vim as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set vim as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = mkIf cfg.default.editor "vim";
        VISUAL = mkIf cfg.default.visual "vim";
      };

      packages = with pkgs; [ (vim-full.override { pythonSupport = true; }) ];
    };

    xdg.configFile = {
      vim = {
        enable = true;
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/configs/vim";
        target = "../.vim";
      };
    };
  };
}
