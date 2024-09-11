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

  cfg = config.${namespace}.programs.terminal.emulators.kitty;
in
{
  options.${namespace}.programs.terminal.emulators.kitty = {
    enable = mkEnableOption "kitty";
    font = mkOpt types.str "Victor Mono" "Font to use for kitty.";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      extraConfig = ''
        # Emoji font
        symbol_map U+1F600-U+1F64F Noto Color Emoji

        # Fallback to Nerd Font Symbols
        symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AA,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 Symbols Nerd Font Mono
      '';

      settings =
        {
          # Fonts
          font_family = cfg.font;
          font_size = 14;

          # Cursor
          cursor_shape = "block";
          disable_ligatures = "cursor";

          # Performance
          repaint_delay = 20;
          input_delay = 2;
          sync_to_monitor = "no";

          # Window
          remember_window_size = "no";
          initial_window_width = 700;
          initial_window_height = 400;
          window_border_width = 0;
          window_margin_width = 0;
          window_padding_width = 0;
          inactive_text_alpha = "1.0";
          background_opacity = "1.0";
          placement_strategy = "center";
          hide_window_decorations = "yes";
          confirm_os_window_close = 0;

          # Tabs
          # tab_bar_edge = "bottom";
          # tab_bar_margin_width = "0.0";
          # tab_bar_min_tabs = 1;
          # tab_bar_style = "powerline";
          # tab_powerline_style = "slanted";
          # tab_separator = " ┇ ";
          # tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
          # active_tab_font_style = "bold";
          # inactive_tab_font_style = "normal";

          # Shell
          shell = ".";
          close_on_child_death = "no";
          # allow_remote_control = "yes";
          term = "xterm-kitty";
        }
        // {
          # Colorscheme - Bamboo
          background = "#252623";
          foreground = "#f1e9d2";
          selection_background = "#5b5e5a";
          selection_foreground = "#f1e9d2";

          cursor = "#fff8f0";
          cursor_text_color = "#0f0800";

          active_tab_background = "#f1e9d2";
          active_tab_foreground = "#111210";
          inactive_tab_background = "#3a3d37";
          inactive_tab_foreground = "#5b5e5a";

          color0 = "#1c1e1b";
          color8 = "#5b5e5a";

          color1 = "#e75a7c";
          color9 = "#e75a7c";

          color2 = "#8fb573";
          color10 = "#8fb573";

          color3 = "#dbb651";
          color11 = "#dbb651";

          color4 = "#57a5e5";
          color12 = "#57a5e5";

          color5 = "#aaaaff";
          color13 = "#aaaaff";

          color6 = "#70c2be";
          color14 = "#70c2be";

          color7 = "#f1e9dc";
          color15 = "#fff8f0";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          hide_window_decorations = "titlebar-only";
          # macos_option_as_alt = "both";
          macos_custom_beam_cursor = "yes";
          macos_thicken_font = 0;
          macos_colorspace = "displayp3";
        };

      shellIntegration = {
        mode = "no-cursor";
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
