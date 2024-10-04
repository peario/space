if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

-- Providers
local providers = { "perl", "ruby", "node" }
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
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
