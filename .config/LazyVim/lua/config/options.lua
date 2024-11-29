-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = ","

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
