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
  options.${namespace}.programs.terminal.emulators.kitty = with types; {
    enable = mkEnableOption "kitty";
    font = mkOpt str "Victor Mono" "Font to use in kitty.";
    fontSize = mkOpt int 15 "Font size to use in kitty.";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      # enable = mkIf (!pkgs.stdenv.isDarwin) true;
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
          italic_font = "auto";
          bold_font = "auto";
          bold_italic_font = "auto";
          font_size = cfg.fontSize;

          # adjust_line_height = 0;
          # adjust_column_width = 0;
          # box_drawing_scale = "0.001, 1, 1.5, 2";

          # Cursor
          cursor_blink_interval = -1;
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
          background = "#2E3440";
          foreground = "#E5E9F0";
          selection_background = "#3F4758";

          cursor = "#81A1C1";
          url_color = "#88C0D0";

          active_tab_foreground = "#88C0D0";
          active_tab_background = "#434C5E";
          inactive_tab_foreground = "#6C7A96";
          inactive_tab_background = "#2E3440";

          # black
          color0 = "#3B4252";
          color8 = "#4C566A";

          # red
          color1 = "#E06C75";
          color9 = "#E06C75";

          # green
          color2 = "#9EC183";
          color10 = "#9EC183";

          # yellow
          color3 = "#EBCB8B";
          color11 = "#EBCB8B";

          # blue
          color4 = "#81A1C1";
          color12 = "#81A1C1";

          # magenta
          color5 = "#B988B0";
          color13 = "#B988B0";

          # cyan
          color6 = "#88C0D0";
          color14 = "#8FBCBB";

          # white
          color7 = "#E5E9F0";
          color15 = "#ECEFF4";
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
