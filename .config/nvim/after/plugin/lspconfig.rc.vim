lua << EOF

-- Add additional capabilities supported by nvim-cmp

local lspconfig = require('lspconfig')

local cmp = require 'cmp'
require("cmp_nvim_ultisnips").setup{}
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local opts = { noremap=true, silent=true }

require'lspconfig'.pyright.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = lspconfig.util.root_pattern('.git'),
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
}

-- nvim-cmp setup
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }),
  snippet = {
    expand = function(args)
    vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'nvim_lsp_signature_help' }
  },
}
EOF
