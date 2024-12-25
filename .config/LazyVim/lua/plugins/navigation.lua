return {
  {
    "ibhagwan/fzf-lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      -- local hasViu = vim.fn.executable("viu") == 1
      -- local hasChafa = vim.fn.executable("chafa") == 1
      -- local hasUeberzugpp = vim.fn.executable("chafa") == 1

      return {
        fzf_colors = true,
        -- Options mainly from https://www.reddit.com/r/neovim/comments/1hhiidm/a_few_nice_fzflua_configurations_now_that_lazyvim
        oldfiles = {
          include_current_session = true,
        },
        previewers = {
          builtin = {
            -- fzf-lua is very fast, but it really struggled to preview a couple files
            -- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
            -- It turns out it was Treesitter having trouble parsing the files.
            -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
            -- (Yes, I know you shouldn't have 100KB minified files in source control.)
            syntax_limit_b = 1024 * 100, -- 100KB

            extensions = {
              -- neovim terminal only supports `viu` block output
              ["png"] = { "viu", "-b" },
              -- by default the filename is added as last argument
              -- if required, use `{file}` for argument positioning
              ["svg"] = { "chafa", "{file}" },
              ["gif"] = { "chafa", "{file}" },
              ["jpg"] = { "ueberzug" },
            },
          },
        },
        grep = {
          -- Check: https://www.reddit.com/r/neovim/comments/1hhiidm/comment/m2rxfhl
          rg_glob = true, -- enable glob parsing
          glob_flag = "--iglob", -- case insensitive globs
          glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        },
      }
    end,
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
