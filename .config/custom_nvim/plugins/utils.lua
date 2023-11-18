local plugins = {
	{
		"akinsho/toggleterm.nvim",
		event = "BufEnter",
		config = function()
			require("toggleterm").setup()
		end,
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
	{ "kevinhwang91/nvim-bqf", event = "VeryLazy" },
	{
		"mbbill/undotree",
		event = "VeryLazy",
	},
	{
		"tpope/vim-speeddating",
		event = "VeryLazy",
	},
}

return plugins
