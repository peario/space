---@class util.plugin
--- Utilities related to plugins
local M = {}

---Retrieves a given plugins specifications
---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---Retrieve a plugins path
---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---Check if plugin is installed
---@param plugin string
---@return boolean
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---Returns a table with the options of a plugin
---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)

  if not plugin then
    return {}
  end

  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---Check if a plugin has loaded
---@param name string Name of plugin
---@return boolean
function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return (Config.plugins[name] and Config.plugins[name]._.loaded) ~= nil
end

return M
