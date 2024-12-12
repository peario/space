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
    types
    ;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.${namespace}.programs.terminal.editors.neovim;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    config = mkOpt (types.enum [
      "AstroNvim"
      "LazyVim"
      "NvChad"
    ]) "LazyVim" "Which config to use";
    default = {
      editor = mkEnableOption "Set neovim as the session ${lib.env}`EDITOR`.";
      visual = mkEnableOption "Set neovim as the session ${lib.env}`VISUAL`.";
    };
  };

  config = mkIf cfg.enable {
    # programs.neovim = {
    #   enable = true;
    #   package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    # };

    home = {
      sessionVariables = {
        EDITOR = mkIf cfg.default.editor "nvim";
        VISUAL = mkIf cfg.default.visual "nvim";
      };

      packages = with pkgs; [
        # Version: nightly (v0.11.0-dev), set within `overlays/neovim/default.nix`
        neovim-unwrapped
        # FIX: Broken install
        # neovide
      ];
    };

    xdg.configFile = {
      neovim = {
        enable = true;
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/.config/${cfg.config}";
        target = "nvim";
      };
    };
  };
}
