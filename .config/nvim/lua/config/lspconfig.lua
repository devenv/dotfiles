local navic = require("nvim-navic")

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require("lspconfig")

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tflint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pyright = { autoImportCompletion = true },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
        reportUnknownArgumentType = true,
        reportUnknownParameterType = true,
        reportMissingTypeStubs = false,
      },
    },
  },
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.ruff.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "/opt/homebrew/bin/ruff", "server" },
  settings = {
    ruff = {
      ignore = {},
    },
  },
  init_options = {
    settings = {
      args = {},
    },
  },
})

require("deno-nvim").setup({
  server = {
    on_attach = on_attach,
    capabilites = capabilities,
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity_limit = "Hint",
  },
  virtual_text = {
    severity_limit = "Hint",
  },
})

-- Additional diagnostic configuration for better visibility
vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.HINT,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
