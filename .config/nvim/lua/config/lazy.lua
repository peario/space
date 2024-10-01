-- package.loaded["lazyvim.config.options"] = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

  vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

--- Register/load `Peario` global before plugins, after lazy.nvim
require("util")

---@param opts LazyConfig
return function(opts)
  opts = vim.tbl_deep_extend("force", {
    spec = {
      -- add LazyVim and import its plugins
      {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {
          news = {
            lazyvim = true,
            neovim = true,
          },
        },
      },
      -- import/override with your plugins
      { import = "plugins" },
    },
    defaults = {
      -- Default: lazy = false,
      -- lazy = true,
    },
    dev = {
      patterns = {},
      fallback = jit.os:find("Windows"),
    },
    install = {
      colorscheme = { "bamboo", "tokyonight", "habamax" },
    },
    checker = { enabled = true },
    change_detection = { notify = false },
    diff = {
      cmd = "delta",
    },
    rocks = {
      enabled = true,
      hererocks = false,
    },
    performance = {
      cache = {
        enabled = true,
        -- disabled_events = {}
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }, opts or {})
  require("lazy").setup(opts)
end
