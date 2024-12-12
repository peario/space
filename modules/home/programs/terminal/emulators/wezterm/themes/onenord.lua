-- OneNord Dark
local dark = {}

local dark_palette = {
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

local dark_active_tab = {
  bg_color = dark_palette.bg,
  fg_color = dark_palette.fg,
}

local dark_inactive_tab = {
  bg_color = dark_palette.bg,
  fg_color = dark_palette.selection_bg,
}

function dark.colors()
  return {
    foreground = dark_palette.fg,
    background = dark_palette.bg,
    cursor_bg = dark_palette.cursor_bg,
    cursor_border = dark_palette.cursor_border,
    cursor_fg = dark_palette.fg,
    selection_bg = dark_palette.selection_bg,
    selection_fg = dark_palette.fg,

    ansi = dark_palette.ansi,
    brights = dark_palette.brights,

    tab_bar = {
      background = dark_palette.bg,
      active_tab = dark_active_tab,
      inactive_tab = dark_inactive_tab,
      inactive_tab_hover = dark_active_tab,
      new_tab = dark_inactive_tab,
      new_tab_hover = dark_active_tab,
      inactive_tab_edge = dark_palette.selection_bg, -- (Fancy tab bar only)
    },
  }
end

function dark.window_frame() -- (Fancy tab bar only)
  return {
    active_titlebar_bg = dark_palette.bg,
    inactive_titlebar_bg = dark_palette.bg,
  }
end

-- OneNord Light
local light = {}

local light_palette = {
  bg = "#F7F8FA",
  fg = "#2E3440",
  cursor_bg = "#3879C5",
  cursor_border = "#3879C5",
  selection_bg = "#EAEBED",

  ansi = {
    "#2E3440",
    "#CB4F53",
    "#48A53D",
    "#EE5E25",
    "#3879C5",
    "#9F4ACA",
    "#3EA1AD",
    "#E5E9F0",
  },
  brights = {
    "#646A76",
    "#D16366",
    "#5F9E9D",
    "#BA793E",
    "#1B40A6",
    "#9665AF",
    "#8FBCBB",
    "#ECEFF4",
  },
}

local light_active_tab = {
  bg_color = light_palette.bg,
  fg_color = light_palette.fg,
}

local light_inactive_tab = {
  bg_color = light_palette.bg,
  fg_color = light_palette.selection_bg,
}

function light.colors()
  return {
    foreground = light_palette.fg,
    background = light_palette.bg,
    cursor_bg = light_palette.selection_bg,
    cursor_border = light_palette.selection_bg,
    cursor_fg = light_palette.fg,
    selection_bg = light_palette.bg,
    selection_fg = light_palette.fg,

    ansi = light_palette.ansi,
    brights = light_palette.brights,

    tab_bar = {
      background = light_palette.bg,
      active_tab = light_active_tab,
      inactive_tab = light_inactive_tab,
      inactive_tab_hover = light_active_tab,
      new_tab = light_inactive_tab,
      new_tab_hover = light_active_tab,
      inactive_tab_edge = light_palette.selection_bg, -- (Fancy tab bar only)
    },
  }
end

function light.window_frame() -- (Fancy tab bar only)
  return {
    active_titlebar_bg = light_palette.bg,
    inactive_titlebar_bg = light_palette.bg,
  }
end

return {
  dark = dark,
  light = light,
}
