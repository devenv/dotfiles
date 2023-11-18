local overrides = require("custom.configs.overrides")

local plugins = {
	{
		"ThePrimeagen/harpoon",
		event = "BufEnter",
		config = function()
			require("harpoon").setup({
				global_settings = {
					save_on_toggle = true,
					save_on_change = true,
					enter_on_sendcmd = false,
					tmux_autoclose_windows = false,
					excluded_filetypes = { "harpoon" },
					mark_branch = false,
					tabline = false,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "ThePrimeagen/harpoon" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-p>"] = require("telescope.actions").cycle_history_prev,
							["<C-n>"] = require("telescope.actions").cycle_history_next,
							["<C-a>"] = require("telescope.actions").send_selected_to_qflist,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("harpoon")
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
					"neotest",
					"neotree",
				},
				under_cursor = true,
				min_count_to_highlight = 1,
			})
		end,
	},
	{
		"wellle/targets.vim",
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
		"bkad/CamelCaseMotion",
		event = "BufEnter",
	},
	{
		"farmergreg/vim-lastplace",
		lazy = false,
	},
}

return plugins
