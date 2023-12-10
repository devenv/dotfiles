local plugins = {
	{
		"catppuccin/nvim",
		event = "BufEnter",
		name = "catppuccin",
		dependencies = {
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
					show_current_context_start = false,
				})
			end,
		},
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = true,
				compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = -0.3, -- percentage of the shade to apply to the inactive window
				},
				styles = {
					comments = {},
					properties = {},
					functions = {},
					keywords = {},
					operators = {},
					conditionals = {},
					loops = {},
					booleans = {},
					numbers = {},
					types = {},
					strings = {},
					variables = {},
				},
				integrations = {
					treesitter = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
					aerial = false,
					alpha = false,
					barbar = false,
					beacon = false,
					cmp = true,
					coc_nvim = false,
					dap = { enabled = true, enable_ui = true },
					dashboard = false,
					fern = false,
					fidget = false,
					gitgutter = false,
					gitsigns = true,
					harpoon = false,
					hop = false,
					illuminate = {
						enabled = true,
						lsp = true,
					},
					indent_blankline = { enabled = true, colored_indent_levels = true },
					leap = false,
					lightspeed = false,
					lsp_saga = false,
					lsp_trouble = false,
					markdown = true,
					mason = true,
					mini = true,
					navic = { enabled = true },
					neogit = true,
					neotest = true,
					neotree = { enabled = false, show_root = true, transparent_panel = true },
					noice = true,
					notify = true,
					nvimtree = true,
					overseer = false,
					pounce = false,
					rainbow_delimiters = false,
					semantic_tokens = true,
					symbols_outline = true,
					telekasten = false,
					telescope = { enabled = true, style = "nvchad" },
					treesitter_context = true,
					ts_rainbow = false,
					vim_sneak = false,
					vimwiki = false,
					which_key = true,
				},
				color_overrides = {},
				highlight_overrides = {
					mocha = function(cp)
						return {
							["@parameter"] = { style = {} },
							Normal = { bg = cp.crust },
							NormalNC = { bg = cp.crust },
							NormalFloat = { fg = cp.text, bg = cp.mantle },
							FloatBorder = {
								fg = cp.mantle,
								bg = cp.mantle,
							},
							CursorLineNr = { fg = cp.green },

							DiagnosticVirtualTextError = { bg = cp.none },
							DiagnosticVirtualTextWarn = { bg = cp.none },
							DiagnosticVirtualTextInfo = { bg = cp.none },
							DiagnosticVirtualTextHint = { bg = cp.none },
							LspInfoBorder = { link = "FloatBorder" },

							MasonNormal = { link = "NormalFloat" },

							IndentBlanklineChar = { fg = cp.surface0 },
							IndentBlanklineContextChar = { fg = cp.surface3, style = { "bold" } },
							IndentBlanklineContextStart = { style = { "bold" } },

							Pmenu = { fg = cp.overlay2, bg = cp.base },
							PmenuBorder = { fg = cp.surface1, bg = cp.base },
							PmenuSel = { bg = cp.green, fg = cp.base },
							CmpItemAbbr = { fg = cp.overlay2 },
							CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
							CmpDoc = { link = "NormalFloat" },
							CmpDocBorder = {
								fg = cp.mantle,
								bg = cp.mantle,
							},

							FidgetTask = { bg = cp.none, fg = cp.surface2 },
							FidgetTitle = { fg = cp.blue, style = { "bold" } },

							NvimTreeRootFolder = { fg = cp.pink },
							NvimTreeIndentMarker = { fg = cp.surface0 },

							TelescopeMatching = { fg = cp.lavender },
							TelescopeResultsDiffAdd = { fg = cp.green },
							TelescopeResultsDiffChange = { fg = cp.yellow },
							TelescopeResultsDiffDelete = { fg = cp.red },

							-- For nvim-treehopper
							TSNodeKey = {
								fg = cp.peach,
								bg = cp.base,
								style = { "bold", "underline" },
							},

							["@keyword.return"] = { fg = cp.pink },
						}
					end,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					progress = {
						enabled = false,
						format = "lsp_progress",
						format_done = "lsp_progress_done",
						throttle = 1000 / 30, -- frequency to update lsp progress message
						view = "mini",
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					hover = {
						enabled = true,
						silent = false, -- set to true to not show a message if hover is not available
						view = nil, -- when nil, use defaults from documentation
						opts = {}, -- merged with defaults from documentation
					},
					signature = {
						enabled = true,
						auto_open = {
							enabled = true,
							trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
							luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
							throttle = 50, -- Debounce lsp signature help request by 50ms
						},
						view = nil, -- when nil, use defaults from documentation
						opts = {}, -- merged with defaults from documentation
					},
					message = {
						-- Messages shown by lsp servers
						enabled = true,
						view = "virtualtext",
						opts = {},
					},
					-- defaults for hover and signature help
					documentation = {
						view = "hover",
						opts = {
							lang = "markdown",
							replace = true,
							render = "compact",
							format = { "{message}" },
							win_options = { concealcursor = "n", conceallevel = 3 },
						},
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				messages = {
					enabled = true, -- enables the Noice messages UI
					view = "notify", -- default view for messages
					view_error = "virtualtext", -- view for errors
					view_warn = "virtualtext", -- view for warnings
					view_history = "messages", -- view for :messages
					view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
				},
			})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
	},
}

return plugins
