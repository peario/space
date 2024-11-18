return {
  -- Filetype plugin and all-arounder
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bibtex" },
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      -- resolve client-server for vimtex <-> nvim.
      --  requires pynvim (python3 provider)
      vim.g.vimtex_compiler_progname = "nvr"

      -- Move auxiliary files to subfolder to reduce clutter
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "./auxiliary",
        out_dir = ".",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- setup a pdf-viewer, will later be switched to a terminal pdf-viewer
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_options = "--reuse-window"

      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_quickfix_mode = 0 -- Don't automatically show/hide quickfix window on save/build
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtext" },
      {
        "<C-c>",
        function()
          local success, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")

          if not success then
            vim.notify(
              "Could not get [b:vimtex]: " .. vimtex,
              vim.log.levels.ERROR,
              { title = "VimTeX: Figures" }
            )
            return
          end

          -- Retrieve the root from the vimtex table
          local root = vimtex.root
          if not root then
            vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          -- Grab word/sentence from current line to use as figure name
          local name = vim.fn.getline(".")
          local line = vim.api.nvim_win_get_cursor(0)[1]
          local min_len = 3

          if string.len(name) <= min_len then
            vim.notify(
              ("No word or sentence at %d.\nMinimum length: %d"):format(line, min_len),
              vim.log.levels.WARN,
              { title = "VimTeX: Figures" }
            )
          end

          vim.cmd('silent !inkfigs create "' .. name .. '" "' .. root .. '/figures/"')
          vim.cmd("w")
        end,
        silent = true,
        desc = "New figure",
        mode = "i",
      },
      {
        "<localLeader>e",
        function()
          local success, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")

          if not success then
            vim.notify(
              "Could not get [b:vimtex]: " .. vimtex,
              vim.log.levels.ERROR,
              { title = "VimTeX: Figures" }
            )
            return
          end

          -- Retrieve the root from the vimtex table
          local root = vimtex.root
          if not root then
            vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          vim.cmd('silent !inkfigs edit "' .. root .. '/figures/" > /dev/null 2>&1 &')
          vim.cmd("redraw!")
        end,
        silent = true,
        desc = "Edit figure",
        mode = "n",
      },
    },
  },
  -- LSP and such for LaTeX
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          auxDirectory = "./auxiliary",
          build = {
            onSave = true,
          },
          latexindent = {
            modifyLineBreaks = true,
          },
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
  -- Make vimtex handle syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = { "latex" },
      },
    },
  },
}
