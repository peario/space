-- NOTE: While the file is called `lsp.lua` it's actually managing
--       formatters, linters and other tools as well. Of course installing them as well.
return {
  -- Installer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "css-lsp",
        "lemminx",
        "sqlls",
        "templ",
        -- Formatter
        "cbfmt",
        "clang-format",
        "crlfmt",
        "goimports-reviser",
        "golines",
        "rustywind",
        "nixpkgs-fmt",
        "xmlformatter",
        -- Linter
        "cpplint",
        "htmlhint",
        "revive",
        "stylelint",
        -- NOTE: Needs to be installed outside of neovim
        -- "sqruff",
        "trivy",
        -- DAP
        -- QoF (Quality of Life), usually commands
        "gomodifytags",
        "iferr",
        "impl",
        "json-to-struct",
        "nilaway",
      },
    },
  },
  -- Formatters
  {
    "stevearc/conform.nvim",
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        -- NOTE: Prettier is managed by `extras.formatting.prettier` and currently manages:
        --         Angular, CSS, Flow, GraphQL, HTML, JSON, JSX, JavaScript, Less, Markdown, SCSS, TypeScript, Vue and YAML
        --       Black is managed by `extras.formatting.black` and currently manages:
        --         Python
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "crlfmt", "goimports-reviser", "golines", "gofumpt" },
        html = { "rustywind", "prettier" },
        markdown = { "cbfmt" },
        -- sql = { "sqruff" },
        svg = { "xmlformatter" },
        xml = { "xmlformatter" },
      },
    },
  },
  -- Linters
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- NOTE: Eslint is managed by `extras.linting.eslint` and currently manages:
        --         JavaScript and TypeScript
        c = { "cpplint", "trivy" },
        cpp = { "cpplint", "trivy" },
        css = { "stylelint" },
        dart = { "trivy" },
        docker = { "trivy" },
        elixir = { "trivy" },
        go = { "revive", "trivy" },
        html = { "htmlhint" },
        java = { "trivy" },
        javascript = { "trivy" },
        php = { "trivy" },
        python = { "trivy" },
        rust = { "trivy" },
        -- sql = { "sqruff" },
        typescript = { "trivy" },
      },
    },
  },
  -- Neovim as LSP
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      -- Just to make sure "ts-node-action" is available.
      -- It's required (not sure if direct or indirect) by `builtins.code_actions.ts_node_action`
      {
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        opts = {},
      },
      -- For those sources which uses "vim.ui.select"
      "ibhagwan/fzf-lua",
      -- For those sources which uses "vim.ui.input"
      "folke/snacks.nvim",
    },
    opts = function(_, opts)
      local h = require("null-ls.helpers")
      local nls = require("null-ls")

      -- Inject tools via Neovim as LSP
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Code Actions
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.code_actions.ts_node_action,
        -- Completion
        nls.builtins.completion.luasnip,
        -- Diagnostics
        nls.builtins.diagnostics.actionlint,
        nls.builtins.diagnostics.commitlint.with({
          runtime_condition = h.cache.by_bufnr(function(params)
            local conf_file_names = { ".commitlintrc", "commitlint.config" }
            local conf_file_exts = { "js", "cjs", "mjs", "ts", "cts" }
            local conf_file_exts_extra = { "json", "yaml", "yml" }

            -- Array with all valid filenames and filetypes for commitlint
            local conf_files = { ".commitlintrc" }

            -- Insert those valid config filetypes and filenames into the array above
            for _, exts_extra in ipairs(conf_file_exts_extra) do
              table.insert(conf_files, ".commitlintrc." .. exts_extra)
            end
            for _, file in ipairs(conf_file_names) do
              for _, exts in ipairs(conf_file_exts) do
                table.insert(conf_files, file .. "." .. exts)
              end
            end

            -- Store first match of valid fileformats if found.
            local config_file_paths = vim.fs.find(conf_files, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            -- If no config has been found, don't run
            return config_file_paths and true or false
          end),
        }),
        nls.builtins.diagnostics.dotenv_linter.with({
          runtime_condition = h.cache.by_bufnr(function(params)
            local buffer_name = vim.fn.bufname(params.bufnr)
            -- Include files containing ".env" but explicitly exclude ".envrc"
            return buffer_name:find("%.env") ~= nil and not buffer_name:find("%.envrc$")
          end),
        }),
        nls.builtins.diagnostics.revive.with({
          -- Make sure that revive checks for config files in project and use if found.
          args = h.cache.by_bufnr(function(params)
            local default_args = { "-formatter", "json", "./..." }

            -- If config file exists, use it.
            local config_file_name = "revive.toml"
            local config_file_path = vim.fs.find(config_file_name, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "-config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.diagnostics.sqruff.with({
          -- Overwrite "sqruff" with a different tool
          command = "squawk",
          -- Make sure that revive checks for config files in project and use if found.
          args = h.cache.by_bufnr(function(params)
            local default_args = {
              "$FILENAME",
            }

            -- If config file exists, use it.
            local config_file_name = ".squawk.toml"
            local config_file_path = vim.fs.find(config_file_name, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "--config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.diagnostics.trivy,
        nls.builtins.diagnostics.zsh,
        -- Formatting
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.goimports_reviser,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.nixfmt,
        nls.builtins.formatting.rustywind,
        nls.builtins.formatting.stylelint,
        -- Hover
        nls.builtins.hover.printenv,
      })
    end,
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    keys = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- Disable the keybind for `K` to allow hover.nvim
      keys[#keys + 1] = { "K", false }
    end,
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      ---@diagnostic disable-next-line: missing-fields
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        cssls = {
          filetypes_include = { "html" },
        },

        ---@diagnostic disable-next-line: missing-fields
        html = {
          filetypes_include = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },

        ---@diagnostic disable-next-line: missing-fields
        ts_ls = {
          filetypes_include = { "html" },
        },

        ---@diagnostic disable-next-line: missing-fields
        vtsls = {
          filetypes_include = { "html" },
        },
      },
    },
  },
}
