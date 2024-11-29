return {
  -- Disable pre-install file-browser
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    -- If ever used, modify so that the options are pleasant
    opts = {
      filesystem = {
        filtered_items = {
          -- Let me see hidden/ignored files for repositories.
          hide_dotfiles = false,
          hide_gitignored = false,
          -- Default and only valid for Windows, since not using on windows, leave as is.
          hide_hidden = true,
        },
      },
    },
    keys = function()
      local nomap = vim.keymap.del

      nomap("n", "<leader>e")
      nomap("n", "<leader>E")
      nomap("n", "<leader>fe")
      nomap("n", "<leader>fE")
    end,
  },

  -- Telescope modifications
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      -- Telescope File Browser :: Neo Tree replacement
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
          "nvim-telescope/telescope.nvim",
          "nvim-lua/plenary.nvim",
        },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      defaults = {
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        path_display = {
          "smart",
        },
        vimgrep_arguments = {
          "rg",
          "--follow", -- Follow symbolic links
          "--hidden", -- Search for hidden files
          "--no-heading", -- Don't group matches by each file
          "--with-filename", -- Print the file path with the matched lines
          "--line-number", -- Show line numbers
          "--column", -- Show column numbers
          "--smart-case", -- Smart case search
          "--color=never", -- Disable colors

          -- Exclude some patterns from search
          "--glob=!**/.git/*",
          "--glob=!**/.idea/*",
          "--glob=!**/.vscode/*",
          "--glob=!**/build/*",
          "--glob=!**/dist/*",
          "--glob=!**/yarn.lock",
          "--glob=!**/package-lock.json",
        },
        file_ignore_patterns = { "node_modules" },
      },
      pickers = {
        find_files = {
          theme = "ivy",
          hidden = true,
          -- needed to exclude some files & dirs from general search
          -- when not included or specified in .gitignore
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },
        },
        git_files = {
          theme = "ivy",
        },
        grep_string = {
          theme = "ivy",
        },
        live_grep = {
          theme = "ivy",
        },
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          grouped = true,
          no_ignore = true,
          hijack_netrw = true,
          create_from_prompt = false,
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        media_files = {
          -- filetypes whitelist
          -- default: { "png", "jpg", "mp4", "webm", "pdf" }
          filetypes = { "png", "jpg", "jpeg", "gif", "mp4", "webm", "pdf" },
          -- find command, default: `fd`
          find_cmd = "rg",
          -- Read at https://github.com/nvim-telescope/telescope-media-files.nvim#prerequisites
          --  for information about required software for images, videos, pdf previews, etc.
        },
        ["ui-select"] = {},
      },
      extensions_list = {
        "file_browser",
        "fzf",
        "media_files",
        "ui-select",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
    keys = {
      {
        "<leader>e",
        "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "Explorer (cwd)",
      },
      { "<leader>E", "<cmd>Telescope file_browser<CR>", desc = "Explorer (root) " },
      {
        "<leader>fe",
        "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc = "Explorer (cwd)",
      },
      { "<leader>fE", "<cmd>Telescope file_browser<CR>", desc = "Explorer (root) " },
      { "<leader>fm", "<cmd>Telescope media_files<CR>", desc = "Find media" },
    },
  },
  { "wsdjeg/vim-fetch" },
  {
    "andymass/vim-matchup",
    lazy = true,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- Remove "," and ";" from flash.nvim.
  -- Either will be used for maplocalleader.
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
        },
      },
    },
  },
}
