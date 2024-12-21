if vim.loader then
  vim.loader.enable(true)
end

-- Load all options before lazy
require("config.options")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
