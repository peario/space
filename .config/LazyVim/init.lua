if vim.loader then
  vim.loader.enable()
end

-- Load all options before lazy
require("config.options")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")({
  -- debug = false,
  profiling = {
    loader = false,
    require = false,
  },
})
