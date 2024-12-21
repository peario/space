local function extend_ft_to_each(luasnip, targets, fts)
  for _, target in ipairs(targets) do
    -- Essentially, search target-, then fts-, then all-snippets.
    luasnip.filetype_extend(target, fts)
  end
end

return {
  -- Enable SuperTab
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- General
      "neovim/nvim-lspconfig",
      -- Snippets :: LuaSnip
      {
        "L3MON4D3/LuaSnip",
        lazy = false,
        dependencies = {
          "rafamadriz/friendly-snippets",
          "nvim-treesitter/nvim-treesitter",
        },
        opts = function()
          -- Add extra snippets from `friendly-snippets`
          local ok, ls = pcall(require, "luasnip")
          if ok then
            extend_ft_to_each(ls, { "javascriptreact", "typescriptreact" }, { "html" })
          end

          -- Custom; my own snippets
          require("luasnip.loaders.from_lua").load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })

          -- Snippets from `friendly-snippets`, among other sources
          require("luasnip.loaders.from_vscode").lazy_load({
            exclude = { "latex" },
          })

          return {
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
            ---@see https://github.com/L3MON4D3/LuaSnip/blob/45db5addf8d0a201e1cf247cae4cdce605ad3768/lua/luasnip/default_config.lua#L20-L99
            snip_env = {
              s = ls.snippet,
              sn = ls.snippet_node,
              isn = ls.indent_snippet_node,
              t = ls.text_node,
              i = ls.insert_node,
              f = ls.function_node,
              c = ls.choice_node,
              d = ls.dynamic_node,
              r = ls.restore_node,
              ai = require("luasnip.nodes.absolute_indexer"),
              events = require("luasnip.util.events"),
              extras = require("luasnip.extras"),
              l = require("luasnip.extras").lambda,
              rep = require("luasnip.extras").rep,
              p = require("luasnip.extras").partial,
              m = require("luasnip.extras").match,
              n = require("luasnip.extras").nonempty,
              dl = require("luasnip.extras").dynamic_lambda,
              fmt = require("luasnip.extras.fmt").fmt,
              fmta = require("luasnip.extras.fmt").fmta,
              matches = require("luasnip.extras.postfix").matches,
              conds = require("luasnip.extras.expand_conditions"),
              conds_expand = require("luasnip.extras.conditions.expand"),
              make_condition = require("luasnip.extras.conditions").make_condition,
              postfix = require("luasnip.extras.postfix").postfix,
              ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix,
              types = require("luasnip.util.types"),
              parse = require("luasnip.util.parser").parse_snippet,
              ms = ls.multi_snippet,
              k = require("luasnip.nodes.key_indexer").new_key,
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
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              lazydev = "[Lua]",
              luasnip = "[Snippet]",
              path = "[Path]",
              buffer = "[Buffer]",
              cmdline = "[Cmdline]",
              git = "[Git]",
              vimtex = "[VimTeX]",
            })[entry.source.name]

            vim_item.dup = ({
              nvim_lsp = 0,
              lazydev = 0,
              luasnip = 0,
              path = 0,
              buffer = 0,
              cmdline = 0,
              git = 0,
              vimtex = 0,
            })[entry.source.name] or 0

            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            local ok, luasnip = pcall(require, "luasnip")
            if ok then
              luasnip.lsp_expand(args.body)
            end
          end,
        },
        mapping = vim.tbl_extend("force", opts.mapping, {
          ["<C-E>"] = cmp.mapping(function(fallback)
            if not require("cmp").abort() then
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-,>"] = cmp.mapping(function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if ls.expandable() then
                ls.expand()
              else
                cmp.confirm({ select = true })
              end
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.locally_jumpable(1) then
              ls.jump(1)
            -- elseif vim.snippet.active({ direction = 1 }) then
            --   vim.schedule(function()
            --     vim.snippet.jump(1)
            --   end)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.locally_jumpable(-1) then
              ls.jump(-1)
            -- elseif vim.snippet.active({ direction = -1 }) then
            --   vim.schedule(function()
            --     vim.snippet.jump(-1)
            --   end)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          --     cmp.select_next_item()
          --   elseif vim.snippet.active({ direction = 1 }) then
          --     vim.schedule(function()
          --       vim.snippet.jump(1)
          --     end)
          --   elseif has_words_before() then
          --     cmp.complete()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif vim.snippet.active({ direction = -1 }) then
          --     vim.schedule(function()
          --       vim.snippet.jump(-1)
          --     end)
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
        }),
      }
    end,
  },
}
