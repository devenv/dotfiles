local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup {
	{
		{"tpope/vim-sensible", lazy=false},
		{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
			config = function () 
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { "python", "bash", "csv", "diff", "json", "lua", "vim", "vimdoc", "sql", "markdown", "yaml", "xml" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },  
				})
			end
		},
		{ "catppuccin/nvim", priority = 1000 }
	}
}

-- Sensible settings
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.mouse = false
vim.o.paste = true
vim.cmd.colorscheme "catppuccin"
