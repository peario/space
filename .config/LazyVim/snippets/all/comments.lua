-- commentstring can be retrieved from `vim.bo.commentstring`,
-- it's modified by `JoosepAlviste/nvim-ts-context-commentstring`

--- Parses `vim.bo.commentstring` to generate a snippet node.
--- The snippet node will contain:
---  1. a text node of start of comment (regardless of block or line comment)
---  2. an input node
---  3. a text node with the end of comment (only if its a block-type comment)
local function comment()
  local cs = vim.bo.commentstring

  --- Parse comment string to add spacing before and after `%s`.
  local scs = cs:gsub("(%S)%%s", "%1 %%s"):gsub("%%s(%S)", "%%s %1")

  --- Contains the comment string split by space
  ---@type string[]
  local parts = {}

  for chars in string.gmatch(scs, "%S+") do
    table.insert(parts, chars)
  end

  -- NOTE: For debugging
  -- vim.notify(
  --   ("Parts amount: `%s`, parts content: `%s`"):format(#parts, table.concat(parts, "`, `")),
  --   vim.log.levels.INFO,
  --   { title = "Commentstring" }
  -- )

  return parts
end

--- Creates a bunch of snippets for comment marks (like todo, fix, perf, etc.)
---@param keywords string[]|nil words to create keyword based comments from.
---@return any[] # array of snippet nodes
local function create_key_snippets(keywords)
  keywords = keywords
    or {
      "todo",
      "fix",
      "note",
      "info",
      "warn",
      "perf",
      "hack",
    }

  ---@type table<string, any>
  local keyword_snippets = {}

  for _, keyword in ipairs(keywords) do
    table.insert(
      keyword_snippets,
      s({
        trig = keyword,
        name = "[Comment] New " .. keyword,
        dscr = "Creates a new " .. (keyword:gsub("^%l+", string.upper)) .. " comment",
      }, {
        d(1, function()
          local cs = comment()

          if #cs == 2 then
            -- Format e.g. // text
            return sn(nil, {
              -- First node (//)
              t(cs[1] .. " " .. (keyword:gsub("^%l+", string.upper))),
              c(1, {
                t(": "),
                sn(
                  nil,
                  fmta([[(<>): ]], {
                    i(1, "..."),
                  })
                ),
              }),
              -- Second (last) node (text)
              i(2, cs[2]),
            })
          elseif #cs == 3 then
            -- Format e.g. /* text */
            return sn(nil, {
              -- First node (/*)
              t(cs[1] .. " " .. (keyword:gsub("^%l+", string.upper))),
              c(1, {
                t(": "),
                sn(
                  nil,
                  fmta([[(<>): ]], {
                    i(1, "..."),
                  })
                ),
              }),
              -- Second node (text)
              i(2, cs[2]),
              -- Third (last) node (*/)
              t(" " .. cs[3]),
              -- Jump outside of comment
              i(3),
            })
          end
        end, {}),
      })
    )
  end

  return keyword_snippets
end

---Returns a collection of comment related snippets
---@return any[]
local function generate_snippets()
  --- Pre-set snippets
  ---@type any[]
  local snippets = {
    s({
      trig = "cmc",
      name = "[Comment] new",
      dscr = "Create a new (line) comment",
      snippetType = "autosnippet",
    }, {
      d(1, function()
        local cs = comment()

        if #cs == 2 then
          return sn(nil, {
            t(cs[1] .. " "),
            i(1, cs[2]),
          })
        elseif #cs == 3 then
          return sn(nil, {
            t(cs[1] .. " "),
            i(1, cs[2]),
            t(" " .. cs[3]),
          })
        end
      end, {}),
    }),
  }

  ---@type any[]
  local key_snippets = create_key_snippets()

  for _, snippet in ipairs(key_snippets) do
    table.insert(snippets, snippet)
  end

  return snippets
end

return generate_snippets()
