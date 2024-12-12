return {
  -- Metrics and productivity tracker
  { "wakatime/vim-wakatime", lazy = false },
  -- More detailed Hover
  {
    "lewis6991/hover.nvim",
    lazy = false,
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        -- require('hover.providers.jira')
        -- require('hover.providers.dap')
        -- require('hover.providers.fold_preview')
        require("hover.providers.diagnostic")
        require("hover.providers.man")
        -- require('hover.providers.dictionary')
      end,
      preview_opts = {
        border = "single",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = { "LSP" },
      mouse_delay = 1000,
    },
    keys = function()
      local ok, hover = pcall(require, "hover")
      local mappings

      if ok then
        mappings = {
          {
            "K",
            hover.hover,
            desc = "hover.nvim",
          },
          {
            "gK",
            hover.hover_select,
            desc = "hover.nvim (select)",
          },
          {
            "<C-p>",
            function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))

              hover.hover_switch("previous", { bufnr = 0, pos = { row, col } })
            end,
            desc = "hover.nvim (previous source)",
          },
          {
            "<C-n>",
            function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))

              hover.hover_switch("next", { bufnr = 0, pos = { row, col } })
            end,
            desc = "hover.nvim (next source)",
          },
        }
      end

      return mappings or {}
    end,
  },
}
