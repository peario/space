{
  config,
  # inputs,
  lib,
  pkgs,
  # system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;
  # inherit (inputs) wezterm;

  cfg = config.${namespace}.programs.terminal.emulators.wezterm;
in
{
  options.${namespace}.programs.terminal.emulators.wezterm = with types; {
    enable = mkEnableOption "WezTerm";
    # font = mkOpt str "Victor Mono" "Font to use in kitty.";
    fontSize = mkOpt str "15" "Font size to use in kitty.";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      package = pkgs.wezterm;

      extraConfig = # lua
        ''
          --- OneNord Dark
          local onenord = {}

          local onenord_palette = {
            bg = "#2E3440",
            fg = "#e0def4",
            cursor_bg = "#81A1C1",
            cursor_border = "#81A1C1",
            selection_bg = "#3F4758",

            ansi = {
              "#3B4252",
              "#BF616A",
              "#A3BE8C",
              "#EBCB8B",
              "#81A1C1",
              "#B988B0",
              "#88C0D0",
              "#E5E9F0",
            },
            brights = {
              "#4C566A",
              "#BF616A",
              "#A3BE8C",
              "#EBCB8B",
              "#81A1C1",
              "#B988B0",
              "#8FBCBB",
              "#ECEFF4",
            },
          }

          local onenord_active_tab = {
            bg_color = onenord_palette.bg,
            fg_color = onenord_palette.fg,
          }

          local onenord_inactive_tab = {
            bg_color = onenord_palette.bg,
            fg_color = onenord_palette.selection_bg,
          }

          function onenord.colors()
            return {
              foreground = onenord_palette.fg,
              background = onenord_palette.bg,
              cursor_bg = onenord_palette.cursor_bg,
              cursor_border = onenord_palette.cursor_border,
              cursor_fg = onenord_palette.fg,
              selection_bg = onenord_palette.selection_bg,
              selection_fg = onenord_palette.fg,

              ansi = onenord_palette.ansi,
              brights = onenord_palette.brights,

              tab_bar = {
                background = onenord_palette.bg,
                active_tab = dark_active_tab,
                inactive_tab = onenord_inactive_tab,
                inactive_tab_hover = onenord_active_tab,
                new_tab = onenord_inactive_tab,
                new_tab_hover = onenord_active_tab,
                inactive_tab_edge = onenord_palette.selection_bg, -- (Fancy tab bar only)
              },
            }
          end

          function onenord.window_frame() -- (Fancy tab bar only)
            return {
              active_titlebar_bg = onenord_palette.bg,
              inactive_titlebar_bg = onenord_palette.bg,
            }
          end

          -- NOTE: The config for wezterm, above is the colorscheme OneNord Dark.

          -- function scheme_for_appearance(appearance)
          --     return wezterm.plugin.require('https://github.com/neapsix/wezterm').moon
          --   -- if appearance:find "Dark" then
          --   --   return wezterm.plugin.require('https://github.com/neapsix/wezterm').main
          --   -- else
          --   --   return wezterm.plugin.require('https://github.com/neapsix/wezterm').dawn
          --   -- end
          -- end

          function use_color(light, dark)
            -- If match, then light, else dark
            return wezterm.gui.get_appearance():find("Dark") and light or dark
          end

          local act = wezterm.action
          -- local theme = scheme_for_appearance(wezterm.gui.get_appearance())
          -- local custom = wezterm.color.get_builtin_schemes()[scheme_for_appearance(wezterm.gui.get_appearance())]
          local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
          local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

          -- This function returns the suggested title for a tab.
          -- It prefers the title that was set via `tab:set_title()`
          -- or `wezterm cli set-tab-title`, but falls back to the
          -- title of the active pane in that tab.
          function tab_title(tab_info)
            local title = tab_info.tab_title
            -- if the tab title is explicitly set, take that
            if title and #title > 0 then
              return title
            end
            -- Otherwise, use the title from the active pane
            -- in that tab
            return tab_info.active_pane.title
          end

          wezterm.on(
            'format-tab-title',
            function(tab, tabs, panes, config, hover, max_width)
              local edge_background = use_color("#fffaf3", "#1f1d2e") -- mantle, surface
              local background = use_color("#faf4ed", "#191724") -- base
              local foreground = use_color("#575279", "#e0def4") -- text

              if tab.is_active then
                background = use_color("#286983", "#31748f") -- blue, pine
                foreground = use_color("#f2e9e1", "#26233a") -- crust, overlay
              elseif hover then
                background = use_color("#907aa9", "#c4a7e7") -- mauve, iris
                foreground = use_color("#f2e9e1", "#26233a") -- crust, overlay
              end

              local edge_foreground = background

              local title = tab_title(tab)

              -- ensure that the titles fit in the available space,
              -- and that we have room for the edges.
              title = wezterm.truncate_right(title, max_width - 2)

              return {
                { Background = { Color = edge_background } },
                { Foreground = { Color = edge_foreground } },
                { Text = SOLID_LEFT_ARROW },
                { Background = { Color = background } },
                { Foreground = { Color = foreground } },
                { Text = title },
                { Background = { Color = edge_background } },
                { Foreground = { Color = edge_foreground } },
                { Text = SOLID_RIGHT_ARROW },
              }
            end
          )

          return {
            -- general
            audible_bell = "Disabled",
            check_for_updates = false,
            enable_scroll_bar = false,
            exit_behavior = "CloseOnCleanExit",
            warn_about_missing_glyphs =  false,
            term = "xterm-256color",

            -- anims
            animation_fps = 1,

            -- Color scheme
            -- color_schemes = {
            --   ["Nord"] = custom,
            -- },
            -- color_scheme = "Nord",
            colors = onenord.colors(),
            window_frame = onenord.window_frame(), -- needed only if using fancy tab bar

            -- Cursor
            cursor_blink_ease_in = 'Constant',
            cursor_blink_ease_out = 'Constant',
            cursor_blink_rate = 700,
            default_cursor_style = "SteadyBar",

            -- font
            font_size = ${cfg.fontSize},
            font = wezterm.font_with_fallback {
              { family = "Hasklug Nerd Font", weight = "Regular" },
              { family = "CaskaydiaCove Nerd Font", weight = "Regular" },
              { family = "Symbols Nerd Font", weight = "Regular" },
              { family = "Noto Color Emoji", weight = "Regular" },
            },

            keys = {
              -- paste from the clipboard
              { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },

              -- paste from the primary selection
              { key = 'S', mods = 'SHIFT|CTRL', action = act.PasteFrom 'PrimarySelection' },
            },

            -- Allow for special characters, mainly {}[]\|@$
            send_composed_key_when_left_alt_is_pressed = true,
            send_composed_key_when_right_alt_is_pressed = true,

            -- Tab bar
            enable_tab_bar = true,
            hide_tab_bar_if_only_one_tab = true,
            show_tab_index_in_tab_bar = false,
            tab_bar_at_bottom = true,
            use_fancy_tab_bar = false,
            -- try and let the tabs stretch instead of squish
            tab_max_width = 10000,

            -- perf
            enable_wayland = true,
            front_end = "WebGpu",
            scrollback_lines = 10000,

            -- term window settings
            adjust_window_size_when_changing_font_size = false,
            inactive_pane_hsb = {
              saturation = 1.0,
              brightness = 0.8
            },
            -- window_background_opacity = 0.85,
            window_background_opacity = 1,
            window_close_confirmation = "NeverPrompt",
            window_decorations = "RESIZE",
            -- window_padding = { left = 12, right = 12, top = 12, bottom = 12, },
            window_padding = { left = 1, right = 1, top = 1, bottom = 1 },
          }
        '';
    };
  };
}
