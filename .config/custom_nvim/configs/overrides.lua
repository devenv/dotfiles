local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"python",
		"markdown",
		"markdown_inline",
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			include_surrounding_whitespace = true,
			keymaps = {
				["aC"] = "@class.outer",
				["iC"] = "@class.outer",
				["ad"] = "@function.outer",
				["id"] = "@function.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ac"] = "@call.outer",
				["ic"] = "@call.inner",
				["as"] = "@block.outer",
				["is"] = "@block.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["cmc"] = "@class.outer",
				["cmd"] = "@function.outer",
				["cma"] = "@parameter.inner",
				["cms"] = "@block.outer",
			},
			swap_previous = {
				["cMc"] = "@class.outer",
				["cMd"] = "@function.outer",
				["cMa"] = "@parameter.inner",
				["cMs"] = "@block.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]d"] = "@function.outer",
				["]s"] = "@block.outer",
			},
			goto_next_end = {
				["]C"] = "@class.outer",
				["]D"] = "@function.outer",
				["]S"] = "@block.outer",
			},
			goto_previous_start = {
				["[d"] = "@function.outer",
				["[s"] = "@block.outer",
			},
			goto_previous_end = {
				["[C"] = "@class.outer",
				["[D"] = "@function.outer",
				["[S"] = "@block.outer",
			},
		},
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettier",

		-- python stuff
		"black",
		"isort",
		"pyright",
		"python-lsp-server",
	},
}

M.gitsigns = {
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 100,
		ignore_whitespace = true,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <abbrev_sha> <author_time:%Y-%m-%d> - <summary>",
}

return M
