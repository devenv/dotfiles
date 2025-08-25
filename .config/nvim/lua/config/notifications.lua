-- Configure smaller, less intrusive notifications globally

-- Override vim.notify to use smaller notifications by default
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  opts = opts or {}
  
  -- Default to smaller notification settings
  opts.timeout = opts.timeout or 2000 -- 2 seconds
  opts.render = opts.render or "compact" -- Compact rendering
  
  -- For common save/write messages, make them even smaller
  if type(msg) == "string" then
    if msg:match("written") or 
       msg:match("%d+L, %d+B") or 
       msg:match("lines yanked") or
       msg:match("formatted") then
      opts.timeout = 1000 -- 1 second for common messages
      opts.title = opts.title or "File"
    end
  end
  
  return original_notify(msg, level, opts)
end

-- Configure LSP progress notifications to be less intrusive
vim.lsp.handlers["$/progress"] = vim.lsp.with(
  vim.lsp.handlers["$/progress"],
  {
    -- Make LSP progress notifications smaller
    format = function(_, result, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local value = result.value
      
      if not value or not value.kind then
        return
      end
      
      -- Only show important progress updates
      if value.kind == "end" and value.message then
        vim.notify(value.message, vim.log.levels.INFO, {
          title = client and client.name or "LSP",
          timeout = 1000, -- Very brief
        })
      end
    end
  }
)