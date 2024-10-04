return {
  postfix(
    { trig = ".bo", name = "[Style] Bold", dscr = "Transform the word to bold" },
    fmta([[**<>**]], {
      d(1, function(_, parent)
        return sn(nil, { t(parent.snippet.env.POSTFIX_MATCH) })
      end),
    })
  ),
  postfix(
    { trig = ".it", name = "[Style] Italic", dscr = "Transform the word to italic" },
    fmta([[*<>*]], {
      d(1, function(_, parent)
        return sn(nil, { t(parent.snippet.env.POSTFIX_MATCH) })
      end),
    })
  ),
  s(
    { trig = "hr", name = "[Structure] Horizontal rule", dscr = "Create a horizontal line" },
    { t({ "---" }) }
  ),
  s(
    { trig = "h1", name = "[Structure] Header 1", dscr = "Create a top-level header, `# <>`" },
    fmta([[# <>]], {
      i(1, "text"),
    })
  ),
  s(
    { trig = "h2", name = "[Structure] Header 2", dscr = "Create a second-level header, `## <>`" },
    fmta([[## <>]], {
      i(1, "text"),
    })
  ),
  s(
    { trig = "h3", name = "[Structure] Header 3", dscr = "Create a third-level header, `### <>`" },
    fmta([[### <>]], {
      i(1, "text"),
    })
  ),
  s(
    {
      trig = "code",
      name = "[Style] Code block",
      dscr = "Create a code block with syntax highlighting",
    },
    fmta(
      [[
      ```<>
      <>
      ```
      ]],
      {
        i(1, "lang"),
        i(2),
      }
    )
  ),
  s(
    { trig = "cite", name = "[Style] Blockqoute", dscr = "Create a blockquote" },
    fmt(
      [[
      > {}
      ]],
      {
        i(1, "text"),
      }
    )
  ),
}
