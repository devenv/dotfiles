-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
}

---@type HLTable
M.add = {
  Normal = { bg = "#111016" },
  CursorLine = { bold = true },
  CursorLineNr = { bold = true },
  DiffChange = { bg = "233", fg = "25" },
  IndentBlanklineContextStart = { bg = "#212121" },
}

return M
