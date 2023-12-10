local plugins = {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-emoji",
			{
				"Exafunction/codeium.vim",
				event = "BufEnter",
				config = function()
					vim.keymap.set("i", "<C-f>", function()
						return vim.fn["codeium#Accept"]()
					end, { expr = true })

					vim.keymap.set("i", "<c-s>", function()
						return vim.fn["codeium#CycleCompletions"](1)
					end, { expr = true })

					vim.keymap.set("i", "<c-w>", function()
						return vim.fn["codeium#CycleCompletions"](-1)
					end, { expr = true })

					vim.keymap.set("i", "<c-x>", function()
						return vim.fn["codeium#Clear"]()
					end, { expr = true })

					vim.keymap.set("i", "<C-f>", function()
						return vim.fn["codeium#Accept"]()
					end, { expr = true })

					vim.keymap.set("i", "<right>", function(fallback)
						if string.find(vim.fn["codeium#GetS     tatusString"](), "/") then
							return vim.fn["codeium#Accept"]()
						else
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<right>", true, false, true),
								"n",
								true
							)
						end
					end, { expr = true })
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp", priority = 50, group_index = 1 },
					{ name = "luasnip", priority = 5, group_index = 1 },
					{ name = "path", priority = 2, group_index = 1 },
					{ name = "vim-dadbod-completion", priority = 2, group_index = 1 },
					{ name = "nvim_lua", priority = 1, group_index = 1 },
					{ name = "emoji", priority = 1, group_index = 1 },
					{
						name = "buffer",
						priority = 1,
						group_index = 1,
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				},
				sorting = {
					priority_weight = 1,
					comparators = {
						cmp.config.compare.score,
						cmp.config.compare.exact,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.recently_used,
						cmp.config.compare.length,
						cmp.config.compare.order,
						cmp.config.compare.sort_text,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-a>"] = cmp.mapping.complete({}),
					["<C-t>"] = cmp.mapping.complete({
						config = {
							sources = {
								{
									name = "buffer",
									priority = 1,
									group_index = 1,
									option = {
										get_bufnrs = function()
											return vim.api.nvim_list_bufs()
										end,
									},
								},
							},
						},
					}),
					["<C-n>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expandable() then
							luasnip.expand()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol",
						maxwidth = 150,
						ellipsis_char = "...",
						before = function(entry, vim_item)
							vim_item.dup = ({
								nvim_lsp = 0,
								nvim_lua = 0,
							})[entry.source.name] or 0
							return vim_item
						end,
					}),
				},
				performance = {
					max_view_entries = 20,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"jose-elias-alvarez/null-ls.nvim",
				event = "VeryLazy",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"onsails/lspkind.nvim",
		event = "InsertEnter",
		config = function()
			require("lspkind").init({
				mode = "symbol_text",
				preset = "codicons",
				symbol_map = {
					Class = "󰠱",
					Color = "󰏘",
					Copilot = "",
					Constant = "󰏿",
					Constructor = "",
					Enum = "",
					EnumMember = "",
					Event = "",
					Field = "󰜢",
					File = "󰈙",
					Folder = "󰉋",
					Function = "󰊕",
					Interface = "",
					Keyword = "󰌋",
					Method = "󰆧",
					Module = "",
					Operator = "󰆕",
					Property = "󰜢",
					Reference = "󰈇",
					Snippet = "",
					Struct = "󰙅",
					Text = "󰉿",
					TypeParameter = "",
					Unit = "󰑭",
					Value = "󰎠",
					Variable = "󰀫",
				},
			})
		end,
	},
	{
		"microsoft/python-type-stubs",
		lazy = false,
	},
}

return plugins
