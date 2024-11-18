-- stylua: ignore
local lorem_words = {
  "Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
  "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
  "magna", "aliqua", "Ut", "enim", "ad", "minim", "veniam", "quis", "nostrud",
  "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea",
  "commodo", "consequat", "Duis", "aute", "irure", "dolor", "in", "reprehenderit",
  "in", "voluptate", "velit", "esse", "cillum", "dolore", "eu", "fugiat", "nulla",
  "pariatur", "Excepteur", "sint", "occaecat", "cupidatat", "non", "proident",
  "sunt", "in", "culpa", "qui", "officia", "deserunt", "mollit", "anim", "id", "est", "laborum"
}

--- Function to generate a sentence with proper capitalization and punctuation
---@return string
local function generate_sentence()
  --- Random sentence length between 6 and 12 words
  local word_count = math.random(6, 12)
  local sentence = {}

  for _ = 1, word_count do
    table.insert(sentence, lorem_words[math.random(#lorem_words)])
  end

  -- Capitalize the first word and add a period at the end
  sentence[1] = sentence[1]:gsub("^%l", string.upper)
  return table.concat(sentence, " ") .. "."
end

--- Function to generate multiple sentences based on user input
---@param args any|nil amount of sentences
---@return string
local function generate_lorem(args)
  local count = type(args) == "number" and args or type(args) == "nil" and 1 or tonumber(args)
  local result = {}

  for _ = 1, count do
    table.insert(result, generate_sentence())
  end

  return table.concat(result, " ")
end

--- INFO: dx (the file name) is in this case short for: Developer experience.
--- Considering we're in `snippets/all`, these snippets are meant to work within any Filetype.
return {
  postfix({
    trig = "lorem",
    name = "[Placeholder] Lorem ipsum",
    dscr = "Creates a lorem ipsum paragraph with `n` sentences of varying length.",
  }, {
    f(function(_, parent)
      local count = parent.snippet.env.POSTFIX_MATCH
      return generate_lorem(count)
    end, {}),
  }),
}
