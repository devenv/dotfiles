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
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
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
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"hrsh7th/cmp-buffer",
		event = "InsertEnter",
	},
	{ "L3MON4D3/LuaSnip", lazy = false },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
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
					["<C-g>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-s>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "copilot" },
							},
						},
					}),
					["<C-a>"] = cmp.mapping.complete({}),
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
		"nvim-telescope/telescope.nvim",
		opts = overrides.mason,
		config = function()
			local trouble = require("trouble.providers.telescope")

			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					layout_strategy = "flex",
					layout_config = {
						flex = {
							width = 0.95,
							height = 0.95,
							flip_columns = 120,
							vertical = {
								preview_height = 0.75,
							},
							horizontal = {
								preview_width = 0.5,
							},
						},
					},

					mappings = {
						i = {
							["<c-t>"] = trouble.open_with_trouble,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-n>"] = actions.cycle_history_next,
						},
						n = {
							["<c-t>"] = trouble.open_with_trouble,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-n>"] = actions.cycle_history_next,
						},
					},
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
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
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
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
	{ "folke/trouble.nvim" },
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
		"JoseConseco/telescope_sessions_picker.nvim",
		lazy = false,
    dependencies = { { "nvim-telescope/telescope.nvim" } },
		config = function()
			require("telescope").load_extension("sessions_picker")
		end,
	},
	{
		"farmergreg/vim-lastplace",
		lazy = false,
	},
	{
		"psf/black",
		event = "BufEnter",
	},
	{
		"ranelpadon/python-copy-reference.vim",
		event = "BufEnter",
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = false,
		build = "make",
		dependencies = { { "junegunn/fzf.vim" } },
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufEnter",
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
		"alfredodeza/pytest.vim",
		event = "BufEnter",
	},
	{
		"tpope/vim-fugitive",
		event = "BufEnter",
	},
	{
		"tpope/vim-dadbod",
		event = "BufEnter",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		event = "BufEnter",
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		event = "BufEnter",
	},
	{
		"tpope/vim-dotenv",
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
}

return plugins