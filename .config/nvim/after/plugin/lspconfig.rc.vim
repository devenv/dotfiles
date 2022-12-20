lua << EOF

-- Add additional capabilities supported by nvim-cmp

local lspconfig = require('lspconfig')

local cmp = require('cmp')
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
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-g>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end
  )}),
  snippet = {
    expand = function(args)
    vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer',
      option = {
          get_bufnrs = function()
              return vim.api.nvim_list_bufs()
          end,
          keyword_length = 1
      }
    },
    { name = 'ultisnips' },
    { name = 'nvim_lsp_signature_help' }
  }),
}
EOF
