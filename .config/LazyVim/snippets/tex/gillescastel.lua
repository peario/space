local ls = require("luasnip")
local lsUtil = require("util.snippets")
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
local ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local matches = require("luasnip.extras.postfix").matches
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local make_condition = require("luasnip.extras.conditions").make_condition
local events = require("luasnip.util.events")
local types = require("luasnip.util.types")
local k = require("luasnip.nodes.key_indexer").new_key

local is_math = make_condition(lsUtil.math)

return {
  s(
    { trig = "template", name = "Basic template", condition = conds_expand.line_begin },
    fmta(
      [[
\documentclass[a4paper]{article}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage[dutch]{babel}
\usepackage{amsmath, amssymb}


% figure support
\usepackage{import}
\usepackage{xifthen}
\pdfminorversion=7
\usepackage{pdfpages}
\usepackage{transparent}
\newcommand{\incfig}[1]{%
	\def\svgwidth{\columnwidth}
	\import{./figures/}{#1.pdf_tex}
}

\pdfsuppresswarningpagegroup=1

\begin{document}
  <>
\end{document}]],
      {
        i(0),
      }
    )
  ),
  s(
    {
      trig = "beg",
      name = "begin{} / end{}",
      condition = conds_expand.line_begin,
      snippetType = "autosnippet",
    },
    fmta(
      [[
\begin{<>}
  <>
\end{<>}
]],
      {
        i(1, "env"),
        i(0),
        rep(1),
      }
    )
  ),
  s({ trig = "...", name = "ldots", snippetType = "autosnippet", priority = 100 }, t([[\ldots]])),
  s(
    { trig = "table", name = "Table environment", condition = conds_expand.line_begin },
    fmta(
      [[
\begin{table}[<>]
  \centering
  \caption{<>}
  \label{tab:<>}
  \begin{tabular}{<>}
    <>
  \end{tabular}
\end{table}
  ]],
      {
        i(1, "htpb"),
        i(2, "caption"),
        i(3, "label"),
        i(4, "c"), -- column specifiers
        f(function(args)
          local cols = args[1][1] or ""
          local result = {}
          for col in cols:gmatch(".") do
            if col:match("[clr]") then
              table.insert(result, "&")
            end
          end
          return table.concat(result, " "):gsub("^&", "") -- Remove leading "&"
        end, { 4 }),
      }
    )
  ),
  s(
    { trig = "fig", name = "Figure environment", condition = conds_expand.line_begin },
    fmta(
      [[
\begin{figure}[<>]
	\centering
	<>
\end{figure}
]],
      {
        i(1, "htpb"), -- Placeholder for the placement specifier
        c(2, {
          i(nil),
          fmta(
            [[
\includegraphics[width=0.8\textwidth]{<>}
\caption{<>}
\label{fig:<>}
]],
            {
              i(1),
              rep(1),
              f(function(args)
                -- Generate sanitized label by replacing non-alphanumeric characters with `-`
                local input = args[1][1] or ""
                return input:gsub("%W+", "-")
              end, { 1 }), -- Dynamic label based on file path
            }
          ),
        }), -- Placeholder for includegraphics command
      }
    )
  ),
  s(
    {
      trig = "enum",
      name = "Enumerate",
      snippetType = "autosnippet",
      condition = conds_expand.line_begin,
    },
    fmta(
      [[
\begin{enumerate}
  \item <>
\end{enumerate}
  ]],
      {
        i(0),
      }
    )
  ),
  s(
    {
      trig = "item",
      name = "Itemize",
      snippetType = "autosnippet",
      condition = conds_expand.line_begin,
    },
    fmta(
      [[
\begin{itemize}
  \item <>
\end{itemize}
  ]],
      {
        i(0),
      }
    )
  ),
  s(
    { trig = "desc", name = "Description", condition = conds_expand.line_begin },
    fmta(
      [[
\begin{description}
  \item[<>] <>
\end{description}
  ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    { trig = "pac", name = "Package", condition = conds_expand.line_begin },
    fmta([[\usepackage<>{<>}<>]], {
      c(1, {
        i(nil),
        sn(t("["), i(nil, "options"), t("]")),
      }),
      i(2, "package"),
      i(0),
    })
  ),
  s({ trig = "=>", name = "implies", snippetType = "autosnippet" }, t([[\implies]])),
  s({ trig = "=<", name = "implied by", snippetType = "autosnippet" }, t([[\impliedby]])),
  s({ trig = "iff", name = "iff", snippetType = "autosnippet", condition = is_math }, t([[\iff]])),
  s(
    { trig = "mk", name = "Math (inline)", snippetType = "autosnippet", wordTrig = false },
    fmta([[$<>$<>]], {
      i(1), -- Placeholder for math content
      f(function(_, snip)
        -- Check if the next character is valid for spacing
        local next_char = snip.env.TM_NEXT_CHAR or ""
        if next_char:match("[,%.%?%-%s]") then
          return ""
        else
          return " "
        end
      end),
    })
  ),
  s(
    { trig = "dm", name = "Math (display)", snippetType = "autosnippet", wordTrig = false },
    fmta(
      [[
\[
  <>
.\] <>
  ]],
      {
        f(function(_, snip)
          -- INFO: Inserts selection (visual) as the first node (if not nil)
          local visual = snip.env.LS_SELECT_RAW
          if visual and #visual > 0 then
            local res = {}
            for _, ele in ipairs(visual or {}) do
              table.insert(res, ele)
            end
            return t(res)
          else
            return i(1)
          end
        end),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "ali",
      name = "Align",
      snippetType = "autosnippet",
      condition = conds_expand.line_begin,
    },
    fmta(
      [[
\begin{align*}
  <>
.\end{align*}
  ]],
      {
        f(function(_, snip)
          -- INFO: Inserts selection (visual) as the first node (if not nil)
          local visual = snip.env.LS_SELECT_RAW
          if visual and #visual > 0 then
            local res = {}
            for _, ele in ipairs(visual or {}) do
              table.insert(res, ele)
            end
            return t(res)
          else
            return i(1)
          end
        end),
      }
    )
  ),
  s(
    { trig = "//", name = "Fraction", snippetType = "autosnippet", condition = is_math },
    fmta([[\frac{<>}{<>}<>]], {
      i(1),
      i(2),
      i(0),
    })
  ),
  s(
    { trig = "/", name = "Fraction" },
    fmta([[\frac{<>}{<>}<>]], {
      f(function(_, snip)
        -- INFO: Inserts selection (visual) as the first node (if not nil)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return i(1, visual)
        else
          return i(1)
        end
      end),
      i(2),
      i(0),
    })
  ),
  s(
    {
      trig = [[((\d+)|(\d*)(\\)?([A-Za-z]+)((\^|_)(\{\d+\}|\d))*)/]],
      name = "Symbol frac",
      regTrig = true,
      snippetType = "autosnippet",
      wordTrig = false,
      condition = is_math,
    },
    fmta([[\frac{<>}{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1] or ""
      end), -- Numerator from regex capture
      i(2),
      i(0),
    })
  ),
  s(
    {
      trig = [[^.*\)/]],
      name = "() frac",
      regTrig = true,
      snippetType = "autosnippet",
      wordTrig = false,
      condition = is_math,
    },
    fmta([[<>{<>}<>]], {
      f(function(_, snip)
        local stripped = snip.env.TM_CURRENT_LINE:sub(1, -2)
        local depth, idx = 0, #stripped
        while idx > 0 do
          local char = stripped:sub(idx, idx)
          if char == ")" then
            depth = depth + 1
          end
          if char == "(" then
            depth = depth - 1
          end
          if depth == 0 then
            break
          end
          idx = idx - 1
        end
        return stripped:sub(1, idx - 1) .. "\\frac{" .. stripped:sub(idx + 1, -1)
      end),
      i(2),
      i(0),
    })
  ),
  s(
    {
      trig = "([A-Za-z])(\\d)",
      name = "auto subscript",
      condition = is_math,
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmta([[<>_<>{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(0),
    })
  ),
  s(
    {
      trig = [[([A-Za-z])_(\d\d)]],
      name = "auto subscript2",
      condition = is_math,
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmta([[<>_{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(0),
    })
  ),
  s(
    { trig = "sympy", name = "sympyblock", wordTrig = false },
    fmta([[sympy <> sympy<>]], {
      i(1),
      i(0),
    })
  ),
  s(
    { trig = "sympy%((.-)%)sympy", name = "sympy", regTrig = true, wordTrig = false },
    fmta([[<>]], {
      f(function(_, snip)
        -- Debug captures
        vim.notify(
          "Captures: " .. vim.inspect(snip.captures),
          vim.log.levels.DEBUG,
          { title = "Capture Debug" }
        )

        local input = snip.captures[1]
        if not input or #input == 0 then
          return ""
        end -- Fallback if capture fails
        vim.notify("Input: " .. vim.inspect(input), vim.log.levels.DEBUG, { title = "Sympy Input" })

        -- Sanitize input
        local sympy_code = input:gsub("\\", ""):gsub("%^", "**"):gsub("{", "("):gsub("}", ")")
        vim.notify("Sanitized code: " .. sympy_code, vim.log.levels.DEBUG, { title = "Sympy Code" })

        -- Python preamble and command
        local preamble = [[
from sympy import *
x, y, z, t = symbols('x y z t')
k, m, n = symbols('k m n', integer=True)
f, g, h = symbols('f g h', cls=Function)
init_printing()
]]
        local command =
          string.format('python3 -c "%s print(latex(%s))"', preamble:gsub("\n", "; "), sympy_code)
        vim.notify(command, vim.log.levels.DEBUG, { title = "Sympy Command" })

        -- Execute and retrieve result
        local handle = io.popen(command)
        if not handle then
          return ""
        end
        local result = handle:read("*a") or ""
        handle:close()

        -- Ensure result is valid
        if #result == 0 then
          return ""
        end
        return result:gsub("\n", "")
      end),
    })
  ),

  -- NOTE: Old one
  --   s(
  --     { trig = "sympy(.*)sympy", name = "sympy", regTrig = true, wordTrig = false },
  --     fmta([[<>]], {
  --       f(function(_, snip)
  --         local input = snip.captures[1]
  --         local sympy_code = input:gsub("\\", ""):gsub("%^", "**"):gsub("{", "("):gsub("}", ")")
  --         local preamble = [[
  -- from sympy import *
  -- x, y, z, t = symbols('x y z t')
  -- k, m, n = symbols('k m n', integer=True)
  -- f, g, h = symbols('f g h', cls=Function)
  -- init_printing()
  -- ]]
  --         local command = string.format('python3 -c "%s print(latex(%s))"', preamble:gsub("\n", "; "), sympy_code)
  --         vim.notify(command, vim.log.levels.DEBUG, { title = "Sympy" })
  --         local handle = io.popen(command)
  --
  --         -- Nil check
  --         if type(handle) == "nil" then return "" end
  --
  --         local result = handle:read("*a")
  --         handle:close()
  --         return result:gsub("\n", "")
  --       end),
  --     })
  --   ),
  s(
    { trig = "math", name = "mathematicablock", wordTrig = false },
    fmta([[math <> math<>]], {
      i(1),
      i(0),
    })
  ),
  s(
    { trig = "math(.*)math", name = "math", wordTrig = false, regTrig = true },
    fmta([[<>]], {
      f(function(_, snip)
        local input = snip.captures[1]
        local mathematica_code = "ToString[" .. input .. ", TeXForm]"
        local command = string.format("wolframscript -code '%s'", mathematica_code)
        local handle = io.popen(command)

        -- Nil check
        if type(handle) == "nil" then
          return ""
        end

        local result = handle:read("*a")
        handle:close()
        return result:gsub("\n", "")
      end),
    })
  ),
  s(
    { trig = "==", name = "equals", snippetType = "autosnippet" },
    fmta([[&= <> \\]], {
      i(0),
    })
  ),
  s({ trig = "!=", name = "not equals", snippetType = "autosnippet" }, t([[\neq]])),
  s(
    { trig = "ceil", name = "ceil", snippetType = "autosnippet", condition = is_math },
    fmta([[\left\lceil <> \right\rceil <>]], { i(1), i(0) })
  ),
  s(
    { trig = "floor", name = "floor", snippetType = "autosnippet", condition = is_math },
    fmta([[\left\lfloor <> \right\rfloor <>]], { i(1), i(0) })
  ),
  s(
    { trig = "pmat", name = "pmat", snippetType = "autosnippet" },
    fmta([[\begin{pmatrix} <> \end{pmatrix} <>]], { i(1), i(0) })
  ),
  s(
    { trig = "bmat", name = "bmat", snippetType = "autosnippet" },
    fmta([[\begin{bmatrix} <> \end{bmatrix} <>]], { i(1), i(0) })
  ),
  s(
    { trig = "()", name = "left( right)", condition = is_math, snippetType = "autosnippet" },
    fmta([[\left( <> \right) <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lr", name = "left( right)" },
    fmta([[\left( <> \right) <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lr(", name = "left( right)" },
    fmta([[\left( <> \right) <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lr|", name = "left| right|" },
    fmta([[\left| <> \right| <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lr{", name = "left{ right}" },
    fmta([[\left{ <> \right} <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lrb", name = "left{ right}" },
    fmta([[\left{ <> \right} <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lr[", name = "left[ right]" },
    fmta([[\left[ <> \right] <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "lra", name = "left< right>", snippetType = "autosnippet" },
    fmt([[\left<{} \right>{}]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    { trig = "conj", name = "conjugate", condition = is_math, snippetType = "autosnippet" },
    fmta([[\overline{<>}<>]], {
      i(1),
      i(0),
    })
  ),
  s(
    { trig = "sum", name = "sum", wordTrig = false },
    fmta([[\sum_{n=<>}^{<>} <>]], {
      i(1, "1"),
      i(2, [[\infty]]),
      i(3, "a_n z^n"),
    })
  ),
  s(
    { trig = "taylor", name = "taylor", wordTrig = false },
    fmta([[\sum_{<>=<>}^{<>} <> (x-a)^<> <>]], {
      i(1, "k"),
      i(2, "0"),
      i(3, [[\infty]]),
      f(function(args)
        return "c_" .. (args[1][1] or "")
      end, { 1 }),
      rep(1),
      i(0),
    })
  ),
  s(
    { trig = "lim", name = "limit", wordTrig = false },
    fmta([[\lim_{<>} \to <>]], {
      i(1, "n"),
      i(2, [[\infty]]),
    })
  ),
  s(
    { trig = "limsup", name = "limsup", wordTrig = false },
    fmta([[\limsup_{<>} \to <>]], {
      i(1, "n"),
      i(2, [[\infty]]),
    })
  ),
  s(
    { trig = "prod", name = "product", wordTrig = false },
    fmta([[\prod_{<>}^{<>} <> <>]], {
      c(1, {
        fmta([[n=<>]], { i(1, "1") }),
        i(nil),
      }),
      i(2, [[\infty]]),
      d(3, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(4),
    })
  ),
  s(
    { trig = "part", name = "d/dx", wordTrig = false },
    fmta([[\frac{\partial <>}{\partial <>}} <>]], {
      i(1, "V"),
      i(2, "x"),
      i(0),
    })
  ),
  s(
    { trig = "sq", name = [[\sqrt{}]], condition = is_math, snippetType = "autosnippet" },
    fmta([[\sqrt{<>} <>]], {
      d(1, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s({ trig = "sr", name = "^2", snippetType = "autosnippet", condition = is_math }, t("^2")),
  s({ trig = "cb", name = "^3", snippetType = "autosnippet", condition = is_math }, t("^3")),
  s(
    { trig = "td", name = "to the ... power", snippetType = "autosnippet", condition = is_math },
    fmta([[^{<>}<>]], { i(1), i(0) })
  ),
  s(
    { trig = "rd", name = "to the ... power", snippetType = "autosnippet", condition = is_math },
    fmta([[^{(<>)}<>]], { i(1), i(0) })
  ),
  s(
    { trig = "__", name = "subscript", snippetType = "autosnippet" },
    fmta([[_{<>}<>]], { i(1), i(0) })
  ),
  s({ trig = "ooo", name = [[\infty]], snippetType = "autosnippet" }, t([[\infty]])),
  s(
    { trig = "rij", name = "mrij" },
    fmta([[(<>_<>)_{<>\in<>}<>]], {
      i(1, "x"),
      i(2, "n"),
      rep(2),
      i(3, [[\N]]),
      i(0),
    })
  ),
  s({ trig = "<=", name = "leq", snippetType = "autosnippet" }, t([[\le]])),
  s({ trig = ">=", name = "geq", snippetType = "autosnippet" }, t([[\ge]])),
  s(
    { trig = "EE", name = "geq", snippetType = "autosnippet", condition = is_math },
    t([[\exists]])
  ),
  s(
    { trig = "AA", name = "forall", snippetType = "autosnippet", condition = is_math },
    t([[\forall]])
  ),
  s({ trig = "xnn", name = "xn", snippetType = "autosnippet", condition = is_math }, t([[x_{n}]])),
  s({ trig = "ynn", name = "yn", snippetType = "autosnippet", condition = is_math }, t([[y_{n}]])),
  s({ trig = "xii", name = "xi", snippetType = "autosnippet", condition = is_math }, t([[x_{i}]])),
  s({ trig = "yii", name = "yi", snippetType = "autosnippet", condition = is_math }, t([[y_{i}]])),
  s({ trig = "xjj", name = "xj", snippetType = "autosnippet", condition = is_math }, t([[x_{j}]])),
  s({ trig = "yjj", name = "yj", snippetType = "autosnippet", condition = is_math }, t([[y_{j}]])),
  s({ trig = "xp1", name = "x", snippetType = "autosnippet", condition = is_math }, t([[x_{n+1}]])),
  s({ trig = "xmm", name = "x", snippetType = "autosnippet", condition = is_math }, t([[x_{m}]])),
  s({ trig = "R0+", name = "R0+", snippetType = "autosnippet" }, t([[\R_0^+]])),
  s(
    { trig = "plot", name = "Plot", wordTrig = false },
    fmta(
      [[
  \begin{figure}[<>]
  	\centering
  	\begin{tikzpicture}
  		\begin{axis}[
  			xmin = <>, xmax = <>,
  			ymin = <>, ymax = <>,
  			axis lines = middle,
  		]
  			\addplot[domain=<>:<>, samples=<>]{<>};
  		\end{axis}
  	\end{tikzpicture}
  	\caption{<>}
  	\label{<>}
  \end{figure}
  ]],
      {
        i(1),
        i(2, "-10"),
        i(3, "10"),
        i(4, "-10"),
        i(5, "10"),
        rep(2),
        rep(3),
        i(6, "100"),
        i(7),
        i(8),
        d(9, function(args)
          return sn(1, {
            i(1, args[8][1] or ""),
          })
        end, { 8 }),
      }
    )
  ),
  s(
    { trig = "nn", name = "Tikz node", wordTrig = false },
    fmta(
      [[
  \node[<>] (<><>) <> {$ <> $};
  <>
    ]],
      {
        i(1),
        i(2),
        -- f(function(args)
        --   return (args[1][1] or ""):gsub("[^0-9a-zA-Z]", "")
        -- end, { 2 }),
        i(3),
        d(4, function(args)
          -- Dynamically mirrors the first node's value
          return sn(1, { i(1, args[1][1] or "") })
        end, { 2 }),
        rep(2),
        i(0),
      }
    )
  ),
  s(
    { trig = "mcal", name = "mathcal", snippetType = "autosnippet", condition = is_math },
    fmta([[\mathcal{<>}<>]], { i(1), i(0) })
  ),
  s({ trig = "lll", name = "l", snippetType = "autosnippet" }, t([[\ell]])),
  s(
    { trig = "nabl", name = "nabla", snippetType = "autosnippet", condition = is_math },
    t([[\nabla]])
  ),
  s(
    { trig = "xx", name = "cross", snippetType = "autosnippet", condition = is_math },
    t([[\times]])
  ),
  s({ trig = "**", name = "cdot", snippetType = "autosnippet", priority = 100 }, t([[\cdot]])),
  s(
    { trig = "norm", name = "norm", snippetType = "autosnippet", condition = is_math },
    fmta([[\|<>\|<>]], { i(1), i(0) })
  ),
  s(
    {
      trig = [[(?<!\\)(sin|cos|arccot|cot|csc|ln|log|exp|star|perp)]],
      name = "ln",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmta([[\<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    {
      trig = "dint",
      name = "integral",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = is_math,
      priority = 300,
    },
    fmta([[\int_{<>}^{<>} <> <>]], {
      i(1, [[-\infty]]), -- lower
      i(2, [[\infty]]), -- upper
      d(3, function(_, snip)
        local visual = snip.env.LS_SELECT_RAW
        if visual and #visual > 0 then
          return sn(1, t(visual))
        else
          return sn(1, i(1))
        end
      end),
      i(0),
    })
  ),
  s(
    {
      trig = [[(?<!\\)(arcsin|arccos|arctan|arccot|arccsc|arcsec|pi|zeta|int)]],
      name = "ln",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      condition = is_math,
      priority = 200,
    },
    fmta([[\<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "->", name = "to", snippetType = "autosnippet", priority = 100, condition = is_math },
    t([[\to]])
  ),
  s({
    trig = "<->",
    name = "leftrightarrow",
    snippetType = "autosnippet",
    priority = 200,
    condition = is_math,
  }, t([[\leftrightarrow]])),
  s(
    { trig = "!>", name = "mapsto", snippetType = "autosnippet", condition = is_math },
    t([[\mapsto]])
  ),
  s(
    { trig = "invs", name = "inverse", snippetType = "autosnippet", condition = is_math },
    t("^{-1}")
  ),
  s(
    { trig = "compl", name = "complement", snippetType = "autosnippet", condition = is_math },
    t("^{c}")
  ),
  s(
    { trig = [[\\\]], name = "setminus", snippetType = "autosnippet", condition = is_math },
    t([[\setminus]])
  ),
  s({ trig = ">>", name = ">>", snippetType = "autosnippet" }, t([[\gg]])),
  s({ trig = "<<", name = "<<", snippetType = "autosnippet" }, t([[\ll]])),
  s({ trig = "~~", name = "~", snippetType = "autosnippet" }, t([[\sim]])),
  s({
    trig = "set",
    name = "set",
    snippetType = "autosnippet",
    wordTrig = false,
    condition = is_math,
  }, fmta([[\{<>\} <>]], { i(1), i(0) })),
  s({ trig = "||", name = "mid", snippetType = "autosnippet" }, t([[\mid]])),
  s(
    { trig = "cc", name = "subset", snippetType = "autosnippet", condition = is_math },
    t([[\subset]])
  ),
  s({ trig = "notin", name = "not in ", snippetType = "autosnippet" }, t([[\not\in]])),
  s({ trig = "inn", name = "in", snippetType = "autosnippet", condition = is_math }, t([[\in]])),
  s({ trig = "NN", name = "n", snippetType = "autosnippet" }, t([[\N]])),
  s({ trig = "Nn", name = "cap", snippetType = "autosnippet" }, t([[\cap]])),
  s({ trig = "UU", name = "cup", snippetType = "autosnippet" }, t([[\cup]])),
  s(
    { trig = "uuu", name = "bigcup", snippetType = "autosnippet" },
    fmta([[\bigcup_{<>} <>]], {
      c(1, {
        fmta([[i \in <>]], { i("I") }),
        i(nil),
      }),
      i(0),
    })
  ),
  s(
    { trig = "nnn", name = "bigcap", snippetType = "autosnippet" },
    fmta([[\bigcap_{<>} <>]], {
      c(1, {
        fmta([[i \in <>]], { i("I") }),
        i(nil),
      }),
      i(0),
    })
  ),
  s({ trig = "OO", name = "emptyset", snippetType = "autosnippet" }, t([[\O]])),
  s({ trig = "RR", name = "real", snippetType = "autosnippet" }, t([[\R]])),
  s({ trig = "QQ", name = "Q", snippetType = "autosnippet" }, t([[\Q]])),
  s({ trig = "ZZ", name = "Z", snippetType = "autosnippet" }, t([[\Z]])),
  s({ trig = "<!", name = "normal", snippetType = "autosnippet" }, t([[\triangleleft]])),
  s({ trig = "<>", name = "hokje", snippetType = "autosnippet" }, t([[\diamond]])),
  s(
    {
      trig = [[(?<!i)sts]],
      name = "text subscript",
      snippetType = "autosnippet",
      regTrig = true,
      condition = is_math,
    },
    fmta([[_\text{<>} <>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    })
  ),
  s(
    { trig = "tt", name = "text", snippetType = "autosnippet", condition = is_math },
    fmta([[\text{<>}<>]], { i(1), i(0) })
  ),
  s(
    {
      trig = "case",
      name = "cases",
      snippetType = "autosnippet",
      condition = is_math,
      wordTrig = false,
    },
    fmta(
      [[
\begin{cases}
  <>
\end{cases}]],
      { i(1) }
    )
  ),
  s(
    { trig = "SI", name = "SI", snippetType = "autosnippet" },
    fmta([[\SI{<>}{<>}]], { i(1), i(2) })
  ),
  s(
    { trig = "bigfun", name = "Big function", snippetType = "autosnippet" },
    fmta(
      [[
\begin{align*}
  <1>: <> &\longrightarrow <> \\
  <4> &\longmapsto <1>(<4>) = <>
.\end{align*}
]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
      }
    )
  ),
  s(
    { trig = "cvec", name = "column vector", snippetType = "autosnippet" },
    fmta(
      [[
\begin{pmatrix} <1>_<2>\\ \vdots\\ <1>_<3> \end{pmatrix}
    ]],
      {
        i(1, "x"),
        i(2, "1"),
        i(3, "n"),
      }
    )
  ),
  s({
    trig = "bar",
    name = "bar",
    regTrig = true,
    snippetType = "autosnippet",
    condition = is_math,
    priority = 10,
  }, fmta([[\overline{<>}<>]], { i(1), i(0) })),
  s(
    {
      trig = [[([a-zA-Z])bar]],
      name = "bar",
      regTrig = true,
      snippetType = "autosnippet",
      condition = is_math,
      priority = 100,
    },
    fmta([[\overline{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    })
  ),
  s({
    trig = "hat",
    name = "hat",
    regTrig = true,
    snippetType = "autosnippet",
    condition = is_math,
    priority = 10,
  }, fmta([[\hat{<>}<>]], { i(1), i(0) })),
  s(
    {
      trig = [[([a-zA-Z])hat]],
      name = "hat",
      regTrig = true,
      snippetType = "autosnippet",
      condition = is_math,
      priority = 100,
    },
    fmta([[\hat{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    })
  ),
  s(
    { trig = "letw", name = "let omega", snippetType = "autosnippet" },
    t([[Let $\Omega \subset \C$ be open.]])
  ),
  s({ trig = "HH", name = "H", snippetType = "autosnippet" }, t([[\mathbb{H}]])),
  s({ trig = "DD", name = "D", snippetType = "autosnippet" }, t([[\mathbb{D}]])),
}
