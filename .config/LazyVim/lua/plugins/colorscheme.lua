return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "frappe",
      },
    },
  },
  -- OneNord :: Mix of Nord and OneDark
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
        conditionals = "italic",
      },
    },
  },
  -- Everforest
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    opts = {
      background = "hard",
      inlay_hints_background = "dimmed",
    },
    config = function(_, opts)
      require("everforest").setup(opts)
    end,
  },
  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
    },
  },

  -- Configure LazyVim to easier change theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onenord",
    },
  },

  -- TokyoNight, keep for reproduction env
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "moon",
    },
  },
}
