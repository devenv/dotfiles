local on_attach = function() end
local capabilities = vim.lsp.protocol.make_client_capabilities()
local navic = require("nvim-navic")

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
  on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    pyright = { autoImportCompletion = true },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
        reportUnknownArgumentType = true,
        reportUnknownParameterType = true,
        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
      },
    },
  },
})

lspconfig.pylsp.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.foldingRangeProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      rope = {
        ropeFolder = ".rope",
      },
      plugins = {
        jedi_completion = { enabled = false, fuzzy = false },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = false },
        jedi_signature_help = { enabled = false },
        jedi_symbols = { enabled = false, all_scopes = false },
        black = {
          enabled = false,
          line_length = 160,
        },
        pycodestyle = { enabled = false },
        flake8 = {
          enabled = false,
          ignore = {},
          maxLineLength = 160,
        },
        ruff = {
          enabled = true,
          lineLength = 160,
          extendIgnore = { "C90", "ARG" }, -- Rules that are additionally ignored by ruff
          extendSelect = { "F401" }, -- Rules that are additionally used by ruff
          severities = { ["D212"] = "I" }, -- Optional table of rules where a custom severity is desired
          unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action
        },
        mypy = { enabled = false },
        isort = { enabled = true, line_length = 160 },
        yapf = { enabled = false },
        pylint = { enabled = false },
        pydocstyle = { enabled = false },
        mccabe = { enabled = false },
        preload = { enabled = false },
        rope_completion = { enabled = false, eager = false },
        rope_autoimport = { enabled = false },
      },
    },
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity_limit = "Warning",
  },
  virtual_text = {
    severity_limit = "Warning",
  },
})