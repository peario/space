local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "sv", "en_us" }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    local ok, cmp = pcall(require, "cmp")

    if ok then
      cmp.setup.buffer({
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "nvim_lsp" },
          { name = "lazydev" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end
  end,
  group = augroup("dadbod_completion"),
})
