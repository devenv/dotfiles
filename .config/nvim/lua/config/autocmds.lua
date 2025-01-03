local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = "100" })
  end,
})

augroup("OpenPrUrlOnPush", { clear = true })
autocmd("User", {
  pattern = "NeogitPushComplete",
  group = "OpenPrUrlOnPush",
  callback = function()
    open_git_branch_in_browser()
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

vim.api.nvim_create_augroup("DisableAutoFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = "DisableAutoFormatOnSave",
  pattern = "*_api_client.py",
  callback = function()
    vim.b.autoformat = false
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "DisableAutoFormatOnSave",
  pattern = "*_api_client.py",
  callback = function()
    vim.cmd("!isort %")
  end,
})
