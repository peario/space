{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.terminal.editors.neovim;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = {
      editor = mkEnableOption "Set neovim as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set neovim as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      # file = mkIf pkgs.stdenv.isDarwin { "Library/Preferences/glow/glow.yml".text = config; };

      sessionVariables = {
        EDITOR = mkIf cfg.default.editor "nvim";
        VISUAL = mkIf cfg.default.visual "nvim";
      };

      packages = [
        pkgs.neovim
        # NOTE: https://github.com/khaneliman/khanelinix/blob/52ec6f4044344e5f0d96e7bb1ae6723891f4e25e/modules/home/programs/terminal/editors/neovim/default.nix#L29
        # khanelivim.packages.${system}.default
      ];
    };

    # sops.secrets = {
    #   wakatime = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
    #     path = "${config.home.homeDirectory}/.wakatime.cfg";
    #   };
    # };

    # xdg.configFile = mkIf pkgs.stdenv.isLinux { "glow/glow.yml".text = config; };
  };
}
