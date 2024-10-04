return {
  -- Generic
  s({
    trig = "cmk",
    name = "[Nix Type] New variable",
    dscr = "Create a new variable",
    snippetType = "autosnippet",
  }, fmta([[<> = <>;<>]], { i(1), i(2), i(0) })),
  s(
    {
      trig = "cmm",
      name = "[Nix Type] New multi-line",
      dscr = "Make a new multi-line segment",
      snippetType = "autosnippet",
    },
    fmta(
      [[
      <> =<>
        ''
          <>
        '';<>
      ]],
      { i(1), i(2), i(3), i(0) }
    )
  ),
  s(
    {
      trig = "cmb",
      name = "[Nix Type] New boolean",
      dscr = "Make a new boolean assignment",
      snippetType = "autosnippet",
    },
    fmta([[<> = <>;<>]], {
      i(1),
      c(2, {
        t("true"),
        t("false"),
        fmta([[<>if <> then <> else <>]], { i(1), i(2), i(3), i(4) }),
        i(nil),
      }),
      i(0),
    })
  ),
  s({
    trig = "cmt",
    name = "[Nix Type] New text",
    dscr = "Make a new text (string) assignment",
    snippetType = "autosnippet",
  }, fmta([[<> = "<>";<>]], { i(1), i(2), i(0) })),
  s(
    {
      trig = "cms",
      name = "[Nix Type] New set",
      dscr = "Make a new attribute set",
      snippetType = "autosnippet",
    },
    fmta([[<> = <>;<>]], {
      i(1),
      c(2, {
        fmta(
          [[
          <>{
            <>
          }<>
          ]],
          { i(1), i(2), i(3) }
        ),
        fmta([[<>{ <> }<>]], { i(1), i(2), i(3) }),
      }),
      i(0),
    })
  ),
  s(
    {
      trig = "cma",
      name = "[Nix Type] New array",
      dscr = "Make a new array assignment",
      snippetType = "autosnippet",
    },
    fmta([[<> = <>;<>]], {
      i(1),
      c(2, {
        fmta(
          [[
          <>[ <> ]<>
          ]],
          { i(1), i(2), i(3) }
        ),
        fmta(
          [[
          <>[
            <>
          ]<>
          ]],
          { i(1), i(2), i(3) }
        ),
      }),
      i(0),
    })
  ),
  s({
    trig = "cmi",
    name = "[Nix Type] Make inline",
    dscr = "Insert a `${var}` string",
    snippetType = "autosnippet",
  }, fmta([[${<>}<>]], { i(1), i(0) })),
}
