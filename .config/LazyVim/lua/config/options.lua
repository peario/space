-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Providers
local providers = { "perl", "ruby", "node" }
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- NOTE: Don't set `vim.g.python3_host_prog`, neovim finds the binary on its own.
vim.g.loaded_python3_provider = 1

-- Indentation
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2

-- Searching
vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading"

-- Language
vim.opt.spelllang = { "sv", "en_us" }

-- Other
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.mousescroll = "ver:2,hor:6"
vim.opt.cmdheight = 0

-- User powershell on windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end
