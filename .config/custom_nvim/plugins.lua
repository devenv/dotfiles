local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"jose-elias-alvarez/null-ls.nvim",
				event = "BufEnter",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
			{
				"psf/black",
				event = "BufEnter",
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			{
				"zbirenbaum/copilot-cmp",
				event = "InsertEnter",
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
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "path", priority = 50, group_index = 1 },
					{ name = "luasnip", priority = 50, group_index = 1 },
					{ name = "nvim_lsp", priority = 40, group_index = 1 },
					{ name = "nvim_lua", priority = 10, group_index = 1 },
					{ name = "vim-dadbod-completion", priority = 2, group_index = 1 },
					{ name = "copilot", priority = 5, group_index = 1 },
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
					priority_weight = 4,
					comparators = {
						cmp.config.compare.exact,
						cmp.config.compare.locality,
						require("copilot_cmp.comparators").prioritize,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
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
					["<C-n>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end),
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
			})
		end,
	},
	{
		"nvim-neotest/neotest",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"folke/neodev.nvim",
			"nvim-neotest/neotest-python",
			{
				"mfussenegger/nvim-dap",
				config = function()
					local dap = require("dap")
					dap.adapters.python = function(cb, config)
						if config.request == "attach" then
							local port = (config.connect or config).port
							local host = (config.connect or config).host or "127.0.0.1"
							cb({
								type = "server",
								port = assert(port, "`connect.port` is required for a python `attach` configuration"),
								host = host,
								options = {
									source_filetype = "python",
								},
							})
						else
							cb({
								type = "executable",
								command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
								args = { "-m", "debugpy.adapter" },
								options = {
									source_filetype = "python",
								},
							})
						end
					end
					dap.configurations.python = {
						{
							type = "python",
							request = "attach",
							name = "Attach",
							port = 5678,
							pythonPath = function()
								return os.getenv("VIRTUAL_ENV") .. "/bin/python"
							end,
						},
					}
				end,
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG" },
						runner = "pytest",
					}),
				},
			})
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
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
		lazy = false,
		config = function()
			require("nvim-tree").setup({
				respect_buf_cwd = true,
				reload_on_bufenter = true,
				sync_root_with_cwd = true,
				view = {
					width = 40,
				},
				actions = {
					open_file = {
						window_picker = {
							enable = false,
						},
					},
				},
			})
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		event = "BufEnter",
		config = function()
			require("lspsaga").setup({
				diagnostic = {
					extend_relatedInformation = true,
					show_code_action = false,
					keys = {
						exec_action = "o",
						quit = "q",
						expand_or_jump = "<CR>",
						quit_in_show = { "q", "<ESC>" },
					},
				},
				beacon = {
					enable = false,
				},
				symbol_in_winbar = {
					enable = false,
				},
				lightbulb = {
					enable = false,
				},
				code_actions = {
					show_server_name = true,
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		config = function()
			require("fzf-lua").setup({
				keymap = {
					fzf = {
						["CTRL-Q"] = "select-all+accept",
					},
				},
			})
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufEnter",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				opts = overrides.treesitter,
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["<leader>ma"] = "@parameter.inner",
							["<leader>mf"] = "@function.outer",
						},
						swap_previous = {
							["<leader>Ma"] = "@parameter.inner",
							["<leader>Mf"] = "@function.outer",
						},
					},
					goto_next_start = {
						["]]"] = "@function.outer",
					},
					goto_previous_start = {
						["[["] = "@function.outer",
					},
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aa"] = "@argument.outer",
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					select = {
						enable = true,
						lookahead = true,
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						include_surrounding_whitespace = false,
					},
				},
			})
		end,
	},
	{
		"tpope/vim-dadbod",
		event = "BufEnter",
		dependencies = {
			{
				"kristijanhusak/vim-dadbod-ui",
				event = "BufEnter",
			},
			{
				"kristijanhusak/vim-dadbod-completion",
				event = "BufEnter",
			},
		},
	},
	{
		"tpope/vim-unimpaired",
		event = "BufEnter",
	},
	{
		"tpope/vim-surround",
		event = "BufEnter",
	},
	{
		"preservim/vimux",
		event = "BufEnter",
	},
	{
		"tpope/vim-dispatch",
		event = "BufEnter",
	},
	{
		"tpope/vim-fugitive",
		event = "BufEnter",
	},
	{
		"tpope/vim-characterize",
		event = "BufEnter",
	},
	{
		"tpope/vim-speeddating",
		event = "BufEnter",
	},
	{
		"tpope/vim-projectionist",
		event = "BufEnter",
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"camspiers/lens.vim",
		event = "BufEnter",
	},
	{
		"madox2/vim-ai",
		lazy = true,
	},
	{
		"svermeulen/vim-subversive",
		event = "BufEnter",
	},
	{
		"tpope/vim-abolish",
		event = "BufEnter",
	},
	{
		"tpope/vim-repeat",
		event = "BufEnter",
	},
	{
		"christoomey/vim-sort-motion",
		event = "BufEnter",
	},
	{
		"michaeljsmith/vim-indent-object",
		event = "BufEnter",
	},
	{
		"wellle/targets.vim",
		event = "BufEnter",
	},
	{
		"bkad/CamelCaseMotion",
		event = "BufEnter",
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"mbbill/undotree",
		event = "BufEnter",
	},
	{
		"mhinz/vim-startify",
		lazy = false,
	},
	{
		"farmergreg/vim-lastplace",
		lazy = false,
	},
	{
		"ranelpadon/python-copy-reference.vim",
		event = "BufEnter",
	},
}

return plugins
