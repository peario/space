{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Manage fonts.";
    fonts = with pkgs;
      mkOpt (listOf package) [
        # Desktop Fonts
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        work-sans
        comic-neue
        source-sans
        inter
        lexend

        # Main font
        victor-mono

        # Emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # Nerd Fonts
        (nerdfonts.override {
          fonts = [ "FiraCode" "Monaspace" "NerdFontsSymbolsOnly" ];
        })
      ] "Custom font packages to install.";
    default = mkOpt types.str "Victor Mono" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };
  };
}