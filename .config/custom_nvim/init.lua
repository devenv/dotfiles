vim.g.loaded_python3_provider = nil
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.pytest_open_errors = 'current'

vim.g.projectionist_heuristics = {
  ["*"] = {
    ["*"] = {
      venv = "source ../venv/bin/activate",
    },
  },
}

local autocmd = vim.api.nvim_create_autocmd

autocmd("User", {
  pattern = "StartifyBufferOpened",
  callback = function()
    vim.cmd("silent Dotenv")
  end,
})
