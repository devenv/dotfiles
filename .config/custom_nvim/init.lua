vim.g.loaded_python3_provider = nil
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.pytest_open_errors = 'current'
vim.cmd("packadd cfilter")

vim.g.projectionist_heuristics = {
  ["*"] = {
    ["*"] = {
      venv = "source ../venv/bin/activate",
    },
  },
}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd


augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "100" })
	end,
})

augroup("OrderImportsOnSave", { clear = true })
autocmd("BufWritePost", {
  pattern = {"*.py"},
  group = "OrderImportsOnSave",
  callback = function()
      vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'source' } } })
  end,
})
