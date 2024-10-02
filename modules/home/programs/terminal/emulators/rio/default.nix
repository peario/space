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

        colors = {
          # Regular colors
          background = "#252623";
          foreground = "#f1e9d2";

          black = "#1c1e1b";
          red = "#e75a7c";
          green = "#8fb573";
          yellow = "#dbb651";
          blue = "#57a5e5";
          magenta = "#aaaaff";
          cyan = "#70c2be";
          white = "#f1e9d2";

          # Light colors
          light-black = "#5b5e5a";
          light-red = "#e75a7c";
          light-green = "#8fb573";
          light-yellow = "#dbb651";
          light-blue = "#57a5e5";
          light-magenta = "#aaaaff";
          light-cyan = "#70c2be";
          light-white = "#fff8f0";
          light-foreground = "#f1e9d2";

          # Cursor
          cursor = "#fff8f0";
          vi-cursor = "#fff8f0";

          # Selection
          selection-foreground = "#f1e9d2";
          selection-background = "#5b5e5a";

          # Search
          search-match-background = "#70c2be";
          search-match-foreground = "#f1e9d2";
          search-focused-match-background = "#dbb651";
          search-focused-match-foreground = "#f1e9d2";
        };
      };
    };
  };
}
