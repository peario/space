-- Use Space for leader
vim.g.mapleader = " "
-- Use Shift + Backspace for local leader
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<S-BS>", false, false, true)

-- Providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.python3_host_prog = "/run/current-system/sw/bin/python3"
vim.g.loaded_python3_provider = 1

-- Indentation
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2

-- Searching
vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading"

-- Language
vim.opt.spelllang = { "en", "sv" }

-- Other
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.mousescroll = "ver:2,hor:6"
vim.opt.cmdheight = 0

-- User powershell on windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end
