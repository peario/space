return {
  s({ trig = "eq", name = "[Compare] Equal", dscr = "Create an equal comparison" }, { t("==") }),
  s(
    { trig = "neq", name = "[Compare] Not equal", dscr = "Create a not equal comparison" },
    { t("!=") }
  ),
  s(
    { trig = "eqe", name = "[Compare] Equal exact", dscr = "Create an exact equal comparison" },
    { t("===") }
  ),
  s(
    { trig = "lt", name = "[Compare] Less than", dscr = "Create a less than comparison" },
    { t("<") }
  ),
  s({
    trig = "lte",
    name = "[Compare] Less than or equal to",
    dscr = "Create a less then or equal comparison",
  }, { t("<=") }),
  s(
    { trig = "gt", name = "[Compare] Greater than", dscr = "Create a greater than comparison" },
    { t(">") }
  ),
  s({
    trig = "gte",
    name = "[Compare] Greater than or equal to",
    dscr = "Create a greater than or equal to comparison",
  }, { t(">=") }),
}
