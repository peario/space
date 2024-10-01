return {
  -- Enable SuperTab
  {
    "hrsh7th/nvim-cmp",
    keys = {
      { "<C-N>", nil, mode = { "n", "s", "i", "c" } },
      { "<C-P>", nil, mode = { "n", "s", "i", "c" } },
    },
    dependencies = {
      -- General
      "neovim/nvim-lspconfig",
      -- Snippets :: LuaSnip
      {
        "L3MON4D3/LuaSnip",
        opts = function()
          require("luasnip.loaders.from_lua").load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })

          return {
            enable_autosnippets = true,
            ---@see https://github.com/L3MON4D3/LuaSnip/blob/45db5addf8d0a201e1cf247cae4cdce605ad3768/lua/luasnip/default_config.lua#L20-L99
            snip_env = {
              s = require("luasnip").snippet,
              sn = require("luasnip").snippet_node,
              t = require("luasnip").text_node,
              i = require("luasnip").insert_node,
              f = require("luasnip").function_node,
              c = require("luasnip").choice_node,
              d = require("luasnip").dynamic_node,
              r = require("luasnip").restore_node,
              ms = require("luasnip").new_multisnippet,
              l = require("luasnip.extras").lambda,
              rep = require("luasnip.extras").rep,
              p = require("luasnip.extras").partial,
              m = require("luasnip.extras").match,
              n = require("luasnip.extras").nonempty,
              dl = require("luasnip.extras").dynamic_lambda,
              fmt = require("luasnip.extras.fmt").fmt,
              fmta = require("luasnip.extras.fmt").fmta,
              matches = require("luasnip.extras.postfix").matches,
              postfix = require("luasnip.extras.postfix").postfix,
              ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix,
              conds = require("luasnip.extras.conditions"),
              conds_expand = require("luasnip.extras.conditions.expand"),
              types = require("luasnip.util.types"),
            },
          }
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      -- cmp modifiers
      "hrsh7th/cmp-nvim-lsp", -- Builtin LSP client
      "hrsh7th/cmp-buffer", -- Buffers
      "hrsh7th/cmp-path", -- Path
      "hrsh7th/cmp-cmdline", -- Search (/) and Command (:)
      "petertriho/cmp-git", -- Git
      "micangl/cmp-vimtex", -- VimTeX
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local ls = require("luasnip")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
            == nil
      end

      -- Setup plugins
      require("cmp_git").setup()

      -- Add git completions in commits
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }),
      })

      -- Add VimTeX completions in tex files
      cmp.setup.filetype({ "plaintex", "tex" }, {
        sources = cmp.config.sources({
          { name = "vimtex" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }),
      })

      -- Use buffer source for `/` and `?` (if `native_menu` is enabled, won't work)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- General config for sources and mapping
      return {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "lazydev" },
          { name = "luasnip" },
          { name = "path" },
        }),
        snippet = {
          expand = function(args)
            local ok, luasnip = pcall(require, "luasnip")
            if ok then
              luasnip.lsp_expand(args.body)
            end
          end,
        },
        mapping = vim.tbl_extend("force", opts.mapping, {
          ["<C-n>"] = cmp.mapping(function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function()
            if ls.choice_active() then
              ls.change_choice(-1)
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.expand_or_jumpable() then
              vim.schedule(function()
                ls.expand_or_jump()
              end)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.jumpable(-1) then
              vim.schedule(function()
                ls.jump(-1)
              end)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      }
    end,
  },
  -- Convert snippets from one engine to another
  {
    "smjonas/snippet-converter.nvim",
    lazy = true,
    enabled = false,
    config = function()
      local template = {
        sources = {
          ultisnips = {
            vim.fn.stdpath("config") .. "/UltiSnips",
          },
        },
        output = {
          -- Specify the output formats and paths
          vscode_luasnip = {
            vim.fn.stdpath("config") .. "/snippets",
          },
        },
      }

      require("snippet_converter").setup({
        templates = { template },
      })
    end,
  },
}
