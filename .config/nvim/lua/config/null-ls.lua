local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
local b = null_ls.builtins
null_ls.setup({
  sources = {
    -- webdev stuff
    b.formatting.prettier.with({ filetypes = { "html", "markdown", "css", "tsx", "lua", "yaml" } }),

    -- Lua
    b.formatting.stylua,

    -- JSON, YAML
    b.diagnostics.spectral,

    -- SQL
    b.diagnostics.sqlfluff.with({
      extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),
    null_ls.builtins.formatting.sqlfluff.with({
      extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),

    -- python
    b.formatting.black.with({
      extra_args = { "--line-length=160" },
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})
