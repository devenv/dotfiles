lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require'completion'.on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[l', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']l', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

end
require'lspconfig'.pyright.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = nvim_lsp.util.root_pattern('.git'),
  settings = {
    python = {
      analysis = {
        extraPaths = {"src"},
        autoImportCompletions = false,
        autoSearchPaths = false,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        reportGeneralTypeIssues = false,
        reportUntypedFunctionDecorator = false,
        reportInvalidTypeVarUse = false,
        reportUnusedVariable = false,
        reportPropertyTypeMismatch = false,
      }
    }
  }
}
-- require'lspconfig'.pylsp.setup{
--   on_attach = on_attach,
--   flags = {
--     debounce_text_changes = 150,
--   },
--   cmd = { "pylsp" },
--   filetypes = { "python" },
--   root_dir = nvim_lsp.util.root_pattern('.git'),
--   settings = {
--     pylsp = {
--       plugins = {
--         jedi_completion = {
--           fuzzy = true,
--         },
--       },
--     },
--   },
-- }

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable signs
    signs = false,
  }
)

EOF