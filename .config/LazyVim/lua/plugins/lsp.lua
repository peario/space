-- NOTE: While the file is called `lsp.lua` it's actually managing
--       formatters, linters and other tools as well. Of course installing them as well.
return {
  -- Installer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "templ",
        "css-lsp",
        "lemminx",
        -- Formatter
        "crlfmt",
        "goimports-reviser",
        "golines",
        "rustywind",
        "cbfmt",
        "nixpkgs-fmt",
        "xmlformatter",
        -- Linter
        "revive",
        "trivy",
        "htmlhint",
        "stylelint",
        -- DAP
        -- QoF (Quality of Life), usually commands
        "iferr",
        "impl",
        "json-to-struct",
        "gomodifytags",
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
        go = { "crlfmt", "goimports-reviser", "golines", "gofumpt" },
        html = { "rustywind", "prettier" },
        markdown = { "cbfmt" },
        nix = { "nixpkgs-fmt" },
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
        c = { "trivy" },
        cpp = { "trivy" },
        cs = { "trivy" }, -- C#
        css = { "stylelint" },
        dart = { "trivy" },
        docker = { "trivy" },
        elixir = { "trivy" },
        go = { "revive", "trivy" },
        helm = { "trivy" },
        html = { "htmlhint" },
        java = { "trivy" },
        javascript = { "trivy" },
        php = { "trivy" },
        python = { "trivy" },
        ruby = { "trivy" },
        rust = { "trivy" },
        terraform = { "trivy" },
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
        nls.builtins.diagnostics.commitlint,
        nls.builtins.diagnostics.dotenv_linter.with({
          runtime_condition = h.cache.by_bufnr(function(params)
            -- Include files containing ".env" but explicitly exclude ".envrc"
            return params.bufname:find("%.env") ~= nil and not params.bufname:find("%.envrc$")
          end),
        }),
        nls.builtins.diagnostics.revive.with({
          -- Make sure that revive checks for config files in project and use if found.
          args = h.cache.by_bufnr(function(params)
            local default_args = { "-formatter", "json", "./..." }

            -- If config file exists, use it.
            local config_file_name = "revive.toml"
            local config_file_path = vim.fs.find(config_file_name, {
              path = params.bufname,
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "-config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.diagnostics.sqlfluff,
        nls.builtins.diagnostics.trivy,
        nls.builtins.diagnostics.zsh,
        -- Formatting
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.goimports_reviser,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.nixpkgs_fmt,
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
    opts = {
      inlay_hints = {
        enabled = true,
      },
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
