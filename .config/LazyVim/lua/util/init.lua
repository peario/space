local LazyUtil = require("lazy.core.util")

---@class util
--- Various utilities used throughout these config files.
---
--- non-`global` modules/classes is written in all lower-case to indicate that it's imported rather than global access.
---@field generic util.generic
---@field map util.map
---@field plugin util.plugin
local M = {}

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Peario"
    return LazyUtil[level](msg, opts)
  end
end

return M
