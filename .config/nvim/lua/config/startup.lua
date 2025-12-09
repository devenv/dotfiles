-- Aggressive dashboard disabling and startup configuration
local M = {}

function M.setup(opts)
  -- Disable startup screen completely
  vim.opt.shortmess:append("I")
  
  -- Primary dashboard killer - runs early
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("DisableDashboard", { clear = true }),
    callback = function()
      -- Only act if no files were opened
      if vim.fn.argc() == 0 then
        local current_buf = vim.api.nvim_get_current_buf()
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype
        local buf_name = vim.api.nvim_buf_get_name(current_buf)
        
        -- Check if we're in a dashboard buffer
        if buftype == "nofile" or 
           filetype == "alpha" or 
           filetype == "dashboard" or 
           filetype == "ministarter" or 
           filetype == "snacks_dashboard" or
           buf_name:match("dashboard") then
          -- Create and switch to empty buffer
          vim.cmd("enew")
          vim.bo.buftype = ""
          vim.bo.filetype = ""
          vim.bo.buflisted = true
          vim.bo.swapfile = true
        elseif buftype == "" and filetype == "" and buf_name == "" then
          -- We have a normal empty buffer, stay in normal mode
        end
      end
    end,
  })
  
  -- Secondary dashboard killer - more aggressive, runs later
  vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("ForceDisableDashboard", { clear = true }),
    once = true,
    callback = function()
      if vim.fn.argc() == 0 then
        local current_buf = vim.api.nvim_get_current_buf()
        local buftype = vim.api.nvim_buf_get_option(current_buf, "buftype")
        local filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
        
        -- Close dashboard and create empty buffer
        if buftype == "nofile" and (
             filetype == "alpha" or 
             filetype == "dashboard" or 
             filetype == "ministarter" or
             filetype == "snacks_dashboard") then
          vim.api.nvim_buf_delete(current_buf, { force = true })
          vim.cmd("enew")
        end
      end
    end,
  })
  
  -- Detect if stdin was used
  vim.api.nvim_create_autocmd("StdinReadPre", {
    callback = function()
      vim.g.started_with_stdin = true
    end,
  })
end

return M
