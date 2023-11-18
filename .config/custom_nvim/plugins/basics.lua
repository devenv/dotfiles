local overrides = require("custom.configs.overrides")

local plugins = {
	{
		"jedrzejboczar/possession.nvim",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-neotest/neotest",
			"rcarriga/nvim-dap-ui",
			"NeogitOrg/neogit",
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
						pcall(function()
							require("neotest").summary.close()
						end)
						pcall(function()
							require("neotest").output_panel.close()
						end)
						pcall(function()
							require("dapui").close()
						end)
						pcall(function()
							require("neogit").close()
						end)
						return true
					end,
					after_load = function()
						vim.cmd("LspRestart")
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
						preserve_layout = true,
						match = {
							buftype = { "NeogitStatus" },
							filetype = { "NeogitStatus" },
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
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("mini.colors").setup()
			require("mini.comment").setup()
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
		"tpope/vim-unimpaired",
		event = "BufEnter",
	},
	{
		"tpope/vim-surround",
		event = "BufEnter",
	},
	{
		"tpope/vim-dispatch",
		event = "VeryLazy",
	},
	{
		"tpope/vim-characterize",
		event = "VeryLazy",
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
}

return plugins
