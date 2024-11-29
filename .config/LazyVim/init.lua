if vim.loader then
  vim.loader.enable()
end

-- Providers
local providers = { "perl", "ruby", "node" }
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

vim.g.loaded_python3_provider = 1
vim.g.python3_host_prog = "/nix/store/zyak8iqzh1ww83qa4sqwwz3qax0lrky7-python3-3.12.7/bin/python3"

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
