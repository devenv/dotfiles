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
