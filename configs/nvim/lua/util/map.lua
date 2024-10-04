---@class util.map
---Management of keybinds
local M = {}

local keymap = vim.keymap

---Set keybind
---@param mode (string|string[])? Which modes to run mapping in, defaults to `n`
---@param key string Which keypress(es) trigger the action
---@param action string|function What happens once triggered
---@param name string? Name/desc of mapping (overwrites `opts.desc`), defaults to `nil` (empty)
---@param opts vim.keymap.set.Opts? All default options (for keymaps) are valid, defaults to `{ noremap = true, silent = true }`
function M.set(mode, key, action, name, opts)
  mode = mode or "n"
  opts = opts or { noremap = true, silent = true }

  if name ~= nil then
    opts.desc = name
  end

  keymap.set(mode, key, action, opts)
end

---Delete keybind
---@param mode (string|string[])? Which mode does the keybind exist in, defaults to `n`
---@param key string What trigger does the keymap have
---@param opts vim.keymap.del.Opts? All default options (for keymaps) are valid
function M.delete(mode, key, opts)
  mode = mode or "n"
  opts = opts or {}

  keymap.del(mode, key, opts)
end

return M
