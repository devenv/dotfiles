local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
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
		"j-hui/fidget.nvim",
		event = "VeryLazy",
	},
	{
		"psf/black",
		event = "VeryLazy",
	},
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
		"nvim-neotest/neotest",
		event = "VeryLazy",
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
				log_level = 5,
				quickfix = {
					enabled = false,
					open = false,
				},
				output = {
					enabled = false,
					open_on_run = false,
				},
				output_panel = {
					enabled = true,
					open_on_run = true,
				},
				status = {
					enabled = true,
					signs = true,
					virtual_text = true,
				},
				summary = {
					animated = true,
					enabled = true,
					expand_errors = true,
					follow = true,
					mappings = {
						attach = "a",
						clear_marked = "M",
						clear_target = "T",
						debug = "d",
						debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						mark = "m",
						next_failed = "J",
						output = "o",
						prev_failed = "K",
						run = "r",
						run_marked = "R",
						short = "O",
						stop = "u",
						target = "t",
						watch = "w",
					},
				},
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG", "-vvv" },
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
		lazy = false,
		config = function()
			require("nvim-tree").setup({
				respect_buf_cwd = false,
				reload_on_bufenter = true,
				sync_root_with_cwd = true,
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.del("n", "<C-k>", { buffer = bufnr })
				end,
				update_focused_file = {
					enable = true,
					update_root = false,
					ignore_list = {},
				},
				diagnostics = {
					enable = false,
					show_on_dirs = false,
					severity = {
						min = vim.diagnostic.severity.ERROR,
						max = vim.diagnostic.severity.ERROR,
					},
				},
				modified = {
					enable = false,
					show_on_dirs = true,
					show_on_open_dirs = true,
				},
				actions = {
					open_file = {
						quit_on_open = true,
						window_picker = {
							enable = false,
						},
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
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
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
		event = "VeryLazy",
		dependencies = {
			{
				"kristijanhusak/vim-dadbod-ui",
				event = "VeryLazy",
			},
		},
	},
	{
		"jedrzejboczar/toggletasks.nvim",
		event = "BufEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"akinsho/toggleterm.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("toggletasks")
			require("toggletasks").auto_spawn({ "SessionLoadPost" }, function(tasks)
				return tasks:with_tag("auto")
			end)

			require("toggletasks").setup({
				silent = false,
				search_paths = {
					".tasks",
				},
				scan = {
					dirs = { os.getenv("HOME"), "../../../" },
				},
				toggleterm = {
					close_on_exit = false,
					hidden = false,
				},
				telescope = {
					spawn = {
						open_single = true,
						show_running = true,
						mappings = {
							select_float = "<C-f>",
							spawn_smart = "<C-a>",
							spawn_all = "<C-A>",
							spawn_selected = "<C-s>",
						},
					},
					select = {
						mappings = {
							select_float = "<C-f>",
							open_smart = "<C-a>",
							open_all = "<C-A>",
							open_selected = "<C-s>",
							kill_smart = "<C-x>",
							kill_all = nil,
							kill_selected = nil,
							respawn_smart = nil,
							respawn_all = nil,
							respawn_selected = nil,
						},
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-p>"] = require("telescope.actions").cycle_history_prev,
							["<C-n>"] = require("telescope.actions").cycle_history_next,
						},
					},
				},
			})
		end,
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
		event = "VeryLazy",
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			vim.cmd("call FugitiveDetect(getcwd())")
		end,
	},
	{
		"tpope/vim-characterize",
		event = "VeryLazy",
	},
	{
		"tpope/vim-speeddating",
		event = "VeryLazy",
	},
	{
		"tpope/vim-projectionist",
		event = "BufEnter",
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
		event = "VeryLazy",
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
		"farmergreg/vim-lastplace",
		lazy = false,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"whiteinge/diffconflicts",
		lazy = false,
	},
	{
		"mbbill/undotree",
		event = "VeryLazy",
	},
	{
		"ranelpadon/python-copy-reference.vim",
		event = "VeryLazy",
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("dap")
		end,
	},
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
					fidget = true,
					gitgutter = false,
					gitsigns = true,
					harpoon = false,
					hop = true,
					illuminate = true,
					indent_blankline = { enabled = true, colored_indent_levels = true },
					leap = false,
					lightspeed = false,
					lsp_saga = false,
					lsp_trouble = false,
					markdown = true,
					mason = true,
					mini = true,
					navic = { enabled = false },
					neogit = false,
					neotest = true,
					neotree = { enabled = true, show_root = true, transparent_panel = true },
					noice = false,
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
		"liuchengxu/vista.vim",
		event = "VeryLazy",
		dependencies = {
			{ "junegunn/fzf.vim", lazy = false },
			{ "junegunn/fzf", lazy = false },
		},
	},
	{
		"jedrzejboczar/possession.nvim",
		lazy = false,
		dependencies = {
			"tpope/vim-fugitive",
		},
		config = function()
			require("telescope").load_extension("possession")
			require("possession").setup({
				silent = true,
				load_silent = true,
				debug = false,
				logfile = true,
				prompt_no_cr = false,
				hooks = {
					before_save = function()
						require("neotest").summary.close()
						require("neotest").output_panel.close()
						require("dapui").close()
						return true
					end,
					after_load = function()
						vim.cmd("call FugitiveDetect(getcwd())")
					end,
				},
				autosave = {
					current = true,
					tmp = true,
					tmp_name = "tmp",
					on_load = true,
					on_quit = true,
				},
				commands = {
					save = "SSave",
					load = "SLoad",
					delete = "SDelete",
					list = "SList",
					rename = "PossessionRename",
					close = "PossessionClose",
					show = "PossessionShow",
					migrate = "PossessionMigrate",
				},
				plugins = {
					delete_hidden_buffers = false,
					nvim_tree = true,
					tabby = true,
					dap = true,
					delete_buffers = true,
					close_windows = {
						match = {
							filetype = { "twiggy" },
						},
					},
				},
				telescope = {
					list = {
						default_action = "load",
						mappings = {
							save = { n = "<c-x>", i = "<c-x>" },
							load = { n = "<c-v>", i = "<c-v>" },
							delete = { n = "<c-t>", i = "<c-t>" },
							rename = { n = "<c-r>", i = "<c-r>" },
						},
					},
				},
			})
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		config = function()
			require("illuminate").configure({
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				delay = 100,
				filetype_overrides = {},
				filetypes_denylist = {
					"fugitive",
					"neotest",
					"neotree",
				},
				under_cursor = true,
				min_count_to_highlight = 1,
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				timeout = 1000,
				max_width = 60,
				top_down = false,
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("dressing").setup({
				input = {
					enabled = true,
					mappings = {
						n = {
							["<Esc>"] = "Close",
							["<CR>"] = "Confirm",
						},
						i = {
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
							["<Up>"] = "HistoryPrev",
							["<Down>"] = "HistoryNext",
						},
					},
				},
				select = {
					enabled = true,
					backend = { "telescope", "fzf", "builtin" },
				},
			})
		end,
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			vim.opt.laststatus = 3
			vim.opt.splitkeep = "screen"
		end,
		opts = {
			animate = {
				enabled = false,
			},
			keys = {
				["q"] = function(win)
					win:close()
				end,
				["Q"] = function(win)
					win.view.edgebar:close()
				end,
				["<c-w>>"] = function(win)
					win:resize("width", 10)
				end,
				["<c-w><lt>"] = function(win)
					win:resize("width", -10)
				end,
				["<c-w>+"] = function(win)
					win:resize("height", 10)
				end,
				["<c-w>-"] = function(win)
					win:resize("height", -10)
				end,
				["<c-w><space>"] = function(win)
					win:resize("width", 100)
					win:resize("height", 30)
				end,
				["<c-w>="] = function(win)
					win.view.edgebar:equalize()
				end,
			},
			bottom = {
				{
					ft = "toggleterm",
					size = { height = 0.4 },
					filter = function(_, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end,
				},
				{ ft = "qf", title = "QuickFix", size = { height = 0.4 } },
				{ ft = "neotest-output-panel", title = "Neotest Output", size = { height = 0.4 } },
				{
					ft = "help",
					size = { height = 0.7 },
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
			},
			left = {
				{
					title = "Nvimtree",
					ft = "NvimTree",
					size = { width = 0.4, height = 0.4 },
				},
				{
					title = "Scopes",
					ft = "dapui_scopes",
					size = { height = 0.3 },
				},
				{
					title = "Watches",
					ft = "dapui_watches",
					size = { width = 40, height = 0.4 },
				},
				{
					title = "Stacks",
					ft = "dapui_stacks",
					size = { height = 0.3 },
				},
			},
			right = {
				{
					title = "Tests",
					ft = "neotest-summary",
					size = { width = 0.3 },
				},
				{
					title = "Branches",
					ft = "twiggy",
					size = { width = 0.3 },
				},
			},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = false,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup({
				controls = {
					element = "repl",
					enabled = false,
				},
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.3,
							},
							{
								id = "watches",
								size = 0.4,
							},
							{
								id = "stacks",
								size = 0.3,
							},
						},
						position = "left",
						size = 20,
					},
					{
						elements = {},
						position = "bottom",
						size = 10,
					},
				},
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("mini.colors").setup()
			require("mini.comment").setup()
			require("mini.move").setup()
			require("mini.bufremove").setup({
				silent = true,
			})
			require("mini.splitjoin").setup({
				mappings = {
					toggle = "gJ",
				},
			})
		end,
	},
	{
		"sodapopcan/vim-twiggy",
		dependencies = {
			"junegunn/gv.vim",
			"tpope/vim-fugitive",
		},
		event = "VeryLazy",
	},
	{
		"tanvirtin/vgit.nvim",
		event = "VeryLazy",
		config = function()
			require("vgit").setup({
				settings = {
					live_blame = {
						enabled = false,
					},
					live_gutter = {
						enabled = true,
						edge_navigation = true,
					},
					authorship_code_lens = {
						enabled = false,
					},
					scene = {
						diff_preference = "split",
					},
					diff_preview = {
						keymaps = {
							buffer_stage = "a",
							buffer_unstage = "u",
							buffer_hunk_stage = "ga",
							buffer_hunk_unstage = "gu",
							toggle_view = "t",
						},
					},
					project_diff_preview = {
						keymaps = {
							buffer_stage = "a",
							buffer_unstage = "u",
							buffer_hunk_stage = "ga",
							buffer_hunk_unstage = "gu",
							buffer_reset = "U",
							stage_all = "A",
							unstage_all = "R",
							reset_all = "X",
						},
					},
					project_commit_preview = {
						keymaps = {
							save = "Q",
						},
					},
				},
			})
		end,
	},
	{ "kevinhwang91/nvim-bqf", event = "VeryLazy" },
}

return plugins
