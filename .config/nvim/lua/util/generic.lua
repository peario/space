---@class util.generic
--- Utilities for handling generic (and semi-generic) data types, i.e lists
local M = {}

-- Most of these utilities are from:
-- [Lazy.nvim] https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/util.lua
-- [LazyVim] https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

---@generic T
---Remove duplicates within list `T[]`
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

---@generic T
---Filters list `T[]` using function `fun(v: T)` and returns the filtered list
---@param list T[]
---@param fn fun(v: T):boolean?
---@return T[]
function M.filter(fn, list)
  local ret = {}
  for _, v in ipairs(list) do
    if fn(v) then
      table.insert(ret, v)
    end
  end
  return ret
end

---@generic T
---Extends list `T[]` with add `T[]`
---@param list T[]
---@param add T[]
---@return T[]
function M.extend(list, add)
  local idx = {}
  for _, v in ipairs(list) do
    idx[v] = v
  end
  for _, a in ipairs(add) do
    if not idx[a] then
      table.insert(list, a)
    end
  end
  return list
end

--- Fast implementation to check if a table is a list
---@param t table
---@return boolean
function M.is_list(t)
  local i = 0
  ---@diagnostic disable-next-line: no-unknown
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

--- Checks if param `v` can be merged
---@param v any
---@return boolean
function M.is_mergable(v)
  return type(v) == "table" and (vim.tbl_isempty(v) or not M.is_list(v))
end

---Performes a natural/normal comparison between two values
---@generic T
---@param a T
---@param b T
---@return boolean # `true` if `a` > `b`
---@see util.generic.compare_inverse for an inverse comparison between values
function M.compare(a, b)
  return a[1] < b[1]
end

---Performes an inverse comparison between two values
---@generic T
---@param a T
---@param b T
---@return boolean # `true` if `a` < `b`
---@see util.generic.compare for a natural comparison between values
function M.compare_inverse(a, b)
  return a[1] > b[1]
end

--- Disclaimer: Not exactly generic, as type `T`, but encompasses multiple data types.
---
--- Sorts an array of numbers or string (not both) in an alphanumerical order,
--- including symbols as `!`, `=`, `&` and so on.
---@generic T : integer|string
---@param list T[]
---@param reverse boolean? if not provided or nil, then `false` is used
---@return T[]
function M.sort(list, reverse)
  -- Performing a sort on an array of type `T` which isn't strings or integers doesn't work in this function
  if type(list[1]) ~= ("string" or "integer") then
    return list
  end

  --- Depending on `@param reverse` switch comparison function
  local compare = reverse and M.compare_inverse or M.compare

  -- Sorts `list` itself without returning it.
  table.sort(list, compare)

  -- `list` has been sorted
  return list
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function M.merge(...)
  local ret = select(1, ...)
  if ret == vim.NIL then
    ret = nil
  end
  for i = 2, select("#", ...) do
    local value = select(i, ...)
    if M.is_mergable(ret) and M.is_mergable(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    elseif value == vim.NIL then
      ret = nil
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

return M
