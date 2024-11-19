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
          function scheme_for_appearance(appearance)
            if appearance:find "Dark" then
              return wezterm.plugin.require('https://github.com/neapsix/wezterm').main
            else
              return wezterm.plugin.require('https://github.com/neapsix/wezterm').dawn
            end
          end

          function use_color(light, dark)
            -- If match, then light, else dark
            return wezterm.gui.get_appearance():find("Dark") and light or dark
            -- if wezterm.gui.get_appearance():find("Dark") then
            --   return light
            -- else
            --   return dark
            -- end
          end

          local act = wezterm.action
          local theme = scheme_for_appearance(wezterm.gui.get_appearance())
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
            colors = theme.colors(),
            window_frame = theme.window_frame(), -- needed only if using fancy tab bar

            -- Cursor
            cursor_blink_ease_in = 'Constant',
            cursor_blink_ease_out = 'Constant',
            cursor_blink_rate = 700,
            default_cursor_style = "SteadyBar",

            -- font
            font_size = ${cfg.fontSize},
            font = wezterm.font_with_fallback {
              -- 'Monaspace Neon Var', -- Monaspace Neon
              -- 'Symbols Nerd Font',
              -- 'Noto Color Emoji'

              { family = 'Monaspace Neon Var', weight = "Regular" }, -- Monaspace Neon
              { family = "Symbols Nerd Font", weight = "Regular" },
              { family = 'Noto Color Emoji', weight = "Regular" },
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
