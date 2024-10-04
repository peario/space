return {
  s(
    { trig = "snipn", name = "[Snip] New", dscr = "Create a new snippet" },
    fmta(
      [[
      <>({ trig = "<>", name = "<>", dscr = "<>" }, {
        t("hello")
      }<>)<>
      ]],
      {
        c(1, { t("s"), t("autosnippet") }),
        i(2, "trigger"),
        i(3, "name"),
        i(4, "description"),
        i(5),
        i(0),
      }
    )
  ),
  s(
    { trig = "snipf", name = "[Snip] New with Format", dscr = "Create a new format snippet" },
    fmta(
      [[
      <>({ trig = "<>", name = "<>", dscr = "<>" },
      fmt(<>, {
        <>
      })<>)<>
      ]],
      {
        c(1, { t("s"), t("autosnippet") }),
        i(2, "trigger"),
        i(3, "name"),
        i(4, "description"),
        i(5, "template"),
        i(6, "params"),
        i(7),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "snipfa",
      name = "[Snip] New with Format (fmta)",
      dscr = "Create a new format snippet (using fmta)",
    },
    fmta(
      [[
      <>({ trig = "<>", name = "<>", dscr = "<>" },
      fmta(<>, {
        <>
      })<>)<>
      ]],
      {
        c(1, { t("s"), t("autosnippet") }),
        i(2, "trigger"),
        i(3, "name"),
        i(4, "description"),
        i(5, "template"),
        i(6, "params"),
        i(7, "options"),
        i(0),
      }
    )
  ),
  s(
    { trig = "snipp", name = "[Snip] Postfix", dscr = "Create a postfix snippet" },
    fmta(
      [[
      postfix({ trig = "<>", name = "<>", dscr = "<>" },
      fmta(<>, {
        <>
      })<>)<>
      ]],
      {
        i(1, "!trigger"),
        i(2, "[scope] name"),
        i(3, "description"),
        i(4, "[[template]]"),
        i(5, "params"),
        i(6),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "snipb",
      name = "[Snip] Base file template",
      dscr = "Base template for new snippet files",
    },
    fmta(
      [[
      local ls = require("luasnip")
      -- some shorthands...
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local l = require("luasnip.extras").lambda
      local rep = require("luasnip.extras").rep
      local p = require("luasnip.extras").partial
      local m = require("luasnip.extras").match
      local n = require("luasnip.extras").nonempty
      local dl = require("luasnip.extras").dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local postfix = require("luasnip.extras.postfix").postfix
      local matches = require("luasnip.extras.postfix").matches
      local conds = require("luasnip.extras.conditions")
      local conds_expand = require("luasnip.extras.conditions.expand")
      local events = require("luasnip.util.events")
      local types = require("luasnip.util.types")

      return {
        <>
      }
      ]],
      { i(0) }
    )
  ),
  s(
    { trig = "snipnd", name = "[Snip] Dynamic node", dscr = "Save time writing dynamic nodes" },
    fmta([[d(<>, function(_, parent) return sn(nil, { <> }) end)<>]], {
      i(1, "index"),
      i(2, "t(parent.snippet.env.POSTFIX_MATCH)"),
      i(0),
    })
  ),
}
