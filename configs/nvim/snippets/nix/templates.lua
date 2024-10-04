return {
  s(
    { trig = "mmod", name = "[Nix Template] Module", dscr = "Base template for nix modules" },
    fmta(
      [[
      { <> }:
      let
        <>

        cfg = config.${namespace}.<identifier>;<>
      in {
        <>options.${namespace}.<identifier> = <>{
          <>
        };<>

        config = <>mkIf cfg.enable {
          <>
        };
      }
      ]],
      {
        i(1, "config, lib, pkgs, namespace, ..."),
        c(2, {
          fmta(
            [[
              inherit (lib<>) <>;<>
            ]],
            {
              i(1),
              i(2, "mkIf"),
              i(0),
            }
          ),
          fmta(
            [[
              inherit (lib) <>;
              inherit (lib.${namespace}) <>;<>
            ]],
            {
              i(1, "mkIf"),
              i(2, "mkBoolOpt"),
              i(0),
            }
          ),
          fmta(
            [[
              inherit (lib) <>;
              inherit (lib.${namespace}) <>;
              inherit (<>) <>;<>
            ]],
            {
              i(1, "mkIf"),
              i(2, "mkBoolOpt"),
              i(3, "inputs"),
              i(4, "hyprland"),
              i(0),
            }
          ),
        }),
        identifier = i(3, "<scope.entity>"),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(0),
      },
      { repeat_duplicates = true }
    )
  ),
  s({
    trig = "mmop",
    name = "[Nix Template] Module options",
    dscr = "Effortlessly write options for the base template - `[Nix] Module`.",
  }, {
    c(1, {
      fmta([[<> = <> <> <> "<>";<>]], {
        i(1),
        i(2, "mkOpt"),
        i(3, "types.int"),
        i(4, "5"),
        i(5, "Amount of ..."),
        i(0),
      }),
      fmta([[<> = <> <> "<>";<>]], {
        i(1, "enable"),
        i(2, "mkBoolOpt"),
        i(3, "false"),
        i(4, "Enable ...?"),
        i(0),
      }),
      fmta([[<> = <> "<>";<>]], {
        i(1, "enable"),
        i(2, "mkEnableOption"),
        i(3, "Enable ...?"),
        i(0),
      }),
    }),
  }),
}
