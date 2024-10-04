-- NOTE: I'm trying to keep the triggers as 2-4 characters long for ease of use
return {
  s(
    { trig = "tog", name = "[Nix] on/off", dscr = "Inserts an `enable = <bool>` statement" },
    fmta([[<>enable = <>;<>]], {
      i(1),
      i(2, "true"),
      i(0),
    })
  ),
  s(
    { trig = "with", name = "[Nix] with", dscr = "Inserts a `with` statement" },
    fmta([[with <>]], {
      i(0, "pkgs; "),
    })
  ),
  s(
    { trig = "let", name = "[Nix] let ... in", dscr = "Inserts a `let ... in` statement" },
    fmta(
      [[
      let <>
      in <>
      ]],
      { i(1), i(0) }
    )
  ),
  s(
    { trig = "imp", name = "[Nix] import", dscr = "Inserts an `{ ... }:` statement" },
    fmta([[{ <> }:<>]], { i(1), i(0) })
  ),
  s(
    { trig = "inh", name = "[Nix] inherit", dscr = "Inserts an `inherit ...;` statement" },
    fmta([[inherit <>;<>]], {
      c(1, {
        fmta([[(<>) <>]], {
          i(1),
          i(2),
        }),
        i(nil),
      }),
      i(0),
    })
  ),
  s(
    { trig = "rec", name = "[Nix] rec", dscr = "Inserts a `rec { ... }` statement" },
    fmta(
      [[
      rec {
        <>
      }<>
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s({ trig = "if", name = "[Nix] if", dscr = "Inserts an `if ... then ... else` statement" }, {
    c(1, {
      fmta([[if <> then <> else <>;<>]], {
        i(1),
        i(2),
        i(3),
        i(0),
      }),
      fmta(
        [[
        if <>
        then <>
        else <>;<>
        ]],
        {
          i(1),
          i(2),
          i(3),
          i(0),
        }
      ),
    }),
  }),
  s(
    {
      trig = "cas",
      name = "[Nix] assign if",
      dscr = "Insert a `x = <mkIf / optional> <trigger> <value>` statement",
    },
    fmta([[<> = <> <> <>;]], {
      i(1),
      c(2, {
        t({ "mkIf" }),
        t({ "optional" }),
      }),
      i(3, "trigger"),
      i(4, "value"),
    })
  ),
}
