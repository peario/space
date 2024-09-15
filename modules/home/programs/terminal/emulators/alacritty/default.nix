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

  cfg = config.${namespace}.programs.terminal.emulators.alacritty;
in
{
  options.${namespace}.programs.terminal.emulators.alacritty = with types; {
    enable = mkEnableOption "Alacritty";
    font = mkOpt str "Victor Mono" "Font to use in alacritty.";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty;

      settings =
        {
          cursor = {
            style = {
              shape = "Block";
              blinking = "Off";
            };
          };

          font = {
            size = 13.0;

            offset = {
              x = 0;
              y = 0;
            };

            glyph_offset = {
              x = 0;
              y = 1;
            };

            normal = {
              family = cfg.font;
            };
            bold = {
              family = cfg.font;
              style = "Bold";
            };
            italic = {
              family = cfg.font;
              style = "italic";
            };
            bold_italic = {
              family = cfg.font;
              style = "bold_italic";
            };
          };

          keyboard = {
            bindings = [
              {
                key = "Q";
                mods = "Command";
                action = "Quit";
              }
              {
                key = "W";
                mods = "Command";
                action = "Quit";
              }
              {
                key = "N";
                mods = "Command";
                action = "CreateNewWindow";
              }
            ];
          };

          mouse = {
            hide_when_typing = true;
          };

          window = {
            dimensions = {
              columns = 0;
              lines = 0;
            };

            padding = {
              x = 10;
              y = 10;
            };

            dynamic_padding = true;
            dynamic_title = true;
            opacity = 0.98;
          };
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux { window.decorations = "None"; }
        // lib.optionalAttrs pkgs.stdenv.isDarwin { window.decorations = "Buttonless"; };
    };
  };
}
