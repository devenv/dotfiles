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
				"zbirenbaum/copilot-cmp",
				event = "BufEnter",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				event = "BufEnter",

				config = function()
					require("copilot").setup({
						panel = {
							enabled = false,
						},
						suggestion = {
							enabled = false,
						},
					})
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
					{ name = "copilot", priority = 5, group_index = 2 },
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
						cmp.config.compare.kind,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.length,
						cmp.config.compare.order,
						cmp.config.compare.sort_text,
						require("copilot_cmp.comparators").prioritize,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-a>"] = cmp.mapping.complete({}),
					["<C-s>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "copilot" },
							},
						},
					}),
					["<C-d>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "luasnip" },
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
		"kevinhwang91/nvim-ufo",
		lazy = false,
		dependencies = { { "kevinhwang91/promise-async" } },
		config = function()
			require("ufo").setup()
		end,
	},
	{
		"utilyre/barbecue.nvim",
		lazy = false,
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
}

return plugins
