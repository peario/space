{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.programs.terminal.emulators.rio;
in
{
  options.${namespace}.programs.terminal.emulators.rio = with types; {
    enable = mkEnableOption "rio";
    font = mkOpt str "Victor Mono" "Font to use in rio.";
  };

  config = mkIf cfg.enable {
    programs.rio = {
      enable = true;

      settings = {
        confirm-before-quit = false;

        line-height = 1.2;

        editor = {
          program = "nvim";
          args = [ ];
        };

        fonts = {
          family = cfg.font;
          size = 14;

          extras = [
            {
              family = "Symbols Nerd Font Mono";
              style = "Normal";
              weight = 400;
            }
          ];

          regular = {
            family = cfg.font;
            style = "Normal";
            weight = 400;
          };

          bold = {
            family = cfg.font;
            style = "Normal";
            weight = 800;
          };

          italic = {
            family = cfg.font;
            style = "Italic";
            weight = 400;
          };

          bold-italic = {
            family = cfg.font;
            style = "Italic";
            weight = 800;
          };

          emoji = {
            family = "Noto Color Emoji";
            style = "Normal";
          };
        };

        window = {
          opacity = 0.9;
          blur = true;
          decorations = "disabled";
        };
      };
    };
  };
}
