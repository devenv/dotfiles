local present, null_ls = pcall(require, "null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with({ filetypes = { "html", "markdown", "css", "tsx", "python", "lua" } }), -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.black.with({
    extra_args = { "--line-length=160" },
  }),
}

null_ls.setup({
  debug = true,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/organizeImports") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.organize_imports()
        end,
      })
    end
  end,
  sources = sources,
})
