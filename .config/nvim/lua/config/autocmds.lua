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
    require("neogit.process").show_console()
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

vim.opt.sessionoptions:append("globals")
vim.api.nvim_create_user_command("Mksession", function(attr)
  vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
  vim.cmd.mksession({ bang = attr.bang, args = attr.fargs })
end, { bang = true, complete = "file", desc = "Save barbar with :mksession", nargs = "?" })
