--@type ChadrcConfig
local M = {}

local highlights = require("custom.highlights")

M.ui = {

	statusline = {
		theme = "vscode_colored",
	},

	tabufline = {
		show_numbers = true,
	},

	hl_override = highlights.override,
	hl_add = highlights.add,

  transparency = false,
  lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  -- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
  extended_integrations = {}, -- these aren't compiled by default, ex: "alpha", "notify"

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "borderless" }, -- borderless / bordered
}

M.plugins = "custom.plugins"

vim.api.nvim_set_option("autoindent", true)
vim.api.nvim_set_option("backspace", "indent,eol,start")
vim.api.nvim_set_option("cursorline", true)
vim.api.nvim_set_option("encoding", "utf-8")
vim.api.nvim_set_option("expandtab", true)
vim.api.nvim_set_option("exrc", true)
vim.api.nvim_set_option("ffs", "unix")
vim.api.nvim_set_option("fileencoding", "utf-8")
vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")
vim.api.nvim_set_option("foldlevelstart", 20)
vim.api.nvim_set_option("foldmethod", "syntax")
vim.api.nvim_set_option("hidden", true)
vim.api.nvim_set_option("history", 1000)
vim.api.nvim_set_option("hlsearch", false)
vim.api.nvim_set_option("ignorecase", true)
vim.api.nvim_set_option("incsearch", true)
vim.api.nvim_set_option("list", true)
vim.api.nvim_set_option("mouse", "")
vim.api.nvim_set_option("compatible", false)
vim.api.nvim_set_option("joinspaces", false)
vim.api.nvim_set_option("spell", false)
vim.api.nvim_set_option("swapfile", false)
vim.api.nvim_set_option("wrap", false)
vim.api.nvim_set_option("nu", true)
vim.api.nvim_set_option("rnu", false)
vim.api.nvim_set_option("scrolljump", 1)
vim.api.nvim_set_option("scrolloff", 10)
vim.api.nvim_set_option(
	"sessionoptions",
	"blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
)
vim.api.nvim_set_option("shiftwidth", 2)
vim.api.nvim_set_option("showmatch", true)
vim.api.nvim_set_option("smartcase", true)
vim.api.nvim_set_option("softtabstop", 2)
vim.api.nvim_set_option("spelllang", "en_us")
vim.api.nvim_set_option("splitbelow", true)
vim.api.nvim_set_option("splitright", true)
vim.api.nvim_set_option("tabstop", 2)
vim.api.nvim_set_option("tags", "~/.local/share/nvim/tags")
vim.api.nvim_set_option("whichwrap", "b,s,[,]")
vim.api.nvim_set_option("undofile", true)
vim.api.nvim_set_option("undolevels", 10000)
vim.api.nvim_set_option("undoreload", 10000)
vim.api.nvim_set_option("clipboard", "")
vim.api.nvim_set_option("makeprg", os.getenv("MAKEPRG"))

vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0

vim.o.exrc = true
vim.o.spellfile = vim.fn.expand("$HOME/Documents/.vimspell.en.add")

vim.o.splitkeep = "screen"

vim.g.twiggy_set_upstream = 1
vim.g.twiggy_refresh_buffers = 1
vim.g.twiggy_prompted_force_push = 1

M.mappings = require("custom.mappings")

return M
