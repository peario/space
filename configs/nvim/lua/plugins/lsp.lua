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
    opts = function(_, opts)
      local nls = require("null-ls")
      -- Inject tools via Neovim as LSP
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Code Actions
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        -- Formatting
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.goimports_reviser,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.nixpkgs_fmt,
        nls.builtins.formatting.rustywind,
        nls.builtins.formatting.stylelint,
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
