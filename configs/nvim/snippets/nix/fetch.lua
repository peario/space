return {
  -- used to retrieve the real hash used for the specified source
  s(
    {
      trig = "fhas",
      name = "[Nix Fetch] Fake Hash",
      dscr = "Inserts a fake hash for files, modules, etc.",
    },
    fmta([[<>;<>]], {
      c(1, {
        t('""'),
        t("lib.fakeHash"),
        t("lib.fakeSha256"),
        t("lib.fakeSha512"),
      }),
      i(0),
    })
  ),
  -- Fetch snippet with multiple sources
  --
  -- Generic structure:
  -- ```nix
  -- fetch<type> {
  --   url = "<>";
  --   hash = <>;
  --   <extra stuff = ...>;
  -- };<>
  -- ```
  s({ trig = "fet", name = "[Nix] Fetch", dscr = "Inserts a fetch definition of your choice" }, {
    c(1, {
      -- fetchurl
      sn(
        nil,
        fmta(
          [[
          fetchurl {
            # fetchurl downloads file of url and stores it unaltered
            # Use `hash` if possible instead of shaXXX versions
            url = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "url"), i(2, "hash"), i(0) }
        )
      ),
      -- fetchzip
      sn(
        nil,
        fmta(
          [[
          fetchzip {
            # fetchzip decompresses archive at url, works with .zip and any tarball
            # Use `hash` if possible instead of shaXXX versions
            url = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "url"), i(2, "hash"), i(0) }
        )
      ),
      -- fetchpatch
      sn(
        nil,
        fmta(
          [[
          fetchpatch {
            # fetchpatch works like "fetchurl" but applies the patch on download
            # Use `hash` if possible instead of shaXXX versions
            url = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "url"), i(2, "hash"), i(0) }
        )
      ),
      -- fetchgit
      sn(
        nil,
        fmta(
          [[
          fetchgit {
            # fetchgit works with essentially any git repository
            # Use `hash` if possible instead of shaXXX versions
            url = "<>";
            rev = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "url"), i(2, "commit/version"), i(3, "hash"), i(0) }
        )
      ),
      -- fetchFromGitHub
      sn(
        nil,
        fmta(
          [[
          fetchFromGitHub {
            # fetchFromGitHub under the hood uses fetchzip or fetchgit (depending on options)
            # Use `hash` if possible instead of shaXXX versions
            owner = "<>";
            repo = "<>";
            rev = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "user/org"), i(2, "name"), i(3, "commit or tag"), i(4, "hash"), i(0) }
        )
      ),
      -- requireFile
      sn(
        nil,
        fmta(
          [[
          requireFile {
            # requireFile is a last-resort workaround, should only be used if absolutely necessary
            # Use `hash` if possible instead of shaXXX versions
            name = "<>";
            url = "<>";
            hash = <>;
          };<>
          ]],
          { i(1, "name of download"), i(2, "url"), i(3, "hash"), i(0) }
        )
      ),
    }),
  }),
}
