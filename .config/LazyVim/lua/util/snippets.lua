local ls = require("luasnip")
-- Abbreviations
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local ai = require("luasnip.nodes.absolute_indexer")
local events = require("luasnip.util.events")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local matches = require("luasnip.extras.postfix").matches
local conds = require("luasnip.extras.expand_conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local make_condition = require("luasnip.extras.conditions").make_condition
local postfix = require("luasnip.extras.postfix").postfix
local ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local M = {}

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
M.copy = function(args)
  return args[1]
end

-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
M.date_input = function(args, snip, old_state, format)
  format = format or "%Y-%m-%d"
  return sn(nil, i(1, os.date(format)))
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
-- $(git config github.user)
M.bash = function(_, _, command)
  local file = io.popen(command, "r")
  local res = {}

  if file == nil then
    return ""
  end

  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

M.part = function(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end

M.pair = function(pair_begin, pair_end, expand_func, ...)
  return s(
    { trig = pair_begin, wordTrig = false },
    { t({ pair_begin }), i(1), t({ pair_end }) },
    { condition = M.part(expand_func, M.part(..., pair_begin, pair_end)) }
  )
end

--- Add as a condition for snippets to only work in math env
M.math = function()
  return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

--- Add as a condition for snippets to only work in certain env
---@param name string
M.env = function(name)
  local is_inside = vim.fn["vimtex#env#is_inside"](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- for TikZ environments. Note that you will need to define new helper functions with this setup
M.tikz = function()
  return M.env("tikzpicture")
end

return M
