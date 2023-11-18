local overrides = require("custom.configs.overrides")

local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
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
		"NeogitOrg/neogit",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		config = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		opts = overrides.gitsigns,
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
								id = "stacks",
								size = 0.3,
							},
						},
						position = "left",
						size = 20,
					},
					{
						elements = {
							{
								id = "watches",
								size = 0.4,
							},
						},
						position = "bottom",
						size = 5,
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
		"nvim-telescope/telescope-dap.nvim",
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("dap")
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
		"NeogitOrg/neogit",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		config = true,
	},
	{
		"whiteinge/diffconflicts",
		lazy = false,
	},
	{
		"ranelpadon/python-copy-reference.vim",
		event = "VeryLazy",
	},
	{
		"psf/black",
		event = "VeryLazy",
	},
}

return plugins
