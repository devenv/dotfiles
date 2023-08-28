local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

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

lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.pylsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		pylsp = {
			configurationSources = { "flake8" },
			plugins = {
				jedi_completion = { enabled = true },
				jedi_hover = { enabled = true },
				jedi_references = { enabled = true },
				jedi_signature_help = { enabled = true },
				jedi_symbols = { enabled = true, all_scopes = true },
				black = {
					enabled = true,
					line_length = 160,
				},
				pycodestyle = { enabled = false },
				flake8 = {
					enabled = true,
					ignore = {},
					maxLineLength = 160,
				},
				mypy = { enabled = false },
				isort = { enabled = true },
				yapf = { enabled = false },
				pylint = { enabled = false },
				pydocstyle = { enabled = false },
				mccabe = { enabled = false },
				preload = { enabled = false },
				rope_completion = { enabled = true },
			},
		},
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = {
      severity_limit = "Hint",
    },
    virtual_text = {
      severity_limit = "Warning",
    },
  }
)

