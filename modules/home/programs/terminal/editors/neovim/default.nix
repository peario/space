{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.${namespace}.programs.terminal.editors.neovim;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    config = mkOpt (types.enum [
      "LazyVim"
      "NvChad"
    ]) "LazyVim" "Which config to use";
    default = {
      editor = mkEnableOption "Set neovim as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set neovim as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = mkIf cfg.default.editor "nvim";
        VISUAL = mkIf cfg.default.visual "nvim";
      };

      packages = with pkgs; [
        # It's version is v0.10.2 and set within `overlays/neovim/default.nix`
        neovim-unwrapped
        # FIX: Broken install
        # neovide
      ];
    };

    # sops.secrets = {
    #   wakatime = {
    #     sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
    #     path = "${config.home.homeDirectory}/.wakatime.cfg";
    #   };
    # };

    xdg.configFile = {
      neovim = {
        enable = true;
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/${cfg.config}";
        target = "nvim";
      };
    };
  };
}
