local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {}

plugins = vim.tbl_extend("force", plugins, require("custom.plugins.basics"))
plugins = vim.tbl_extend("force", plugins, require("custom.plugins.nav"))
plugins = vim.tbl_extend("force", plugins, require("custom.plugins.lsp"))
plugins = vim.tbl_extend("force", plugins, require("custom.plugins.dev"))
plugins = vim.tbl_extend("force", plugins, require("custom.plugins.utils"))
plugins = vim.tbl_extend("force", plugins, require("custom.plugins.ui"))

return plugins
