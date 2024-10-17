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
vim.api.nvim_set_option("sessionoptions", "blank,buffers,curdir,tabpages,winsize,winpos,localoptions")
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

vim.g.loaded_python3_provider = nil
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.pytest_open_errors = "current"
vim.cmd("packadd cfilter")
vim.cmd("set nowrap")

vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.shada = "!,'100,<1000,s100,h"
vim.o.shadafile = vim.fn.expand("$HOME/.local/share/shada/main.shada")

vim.g.sort_motion = "gk"
vim.g.sort_motion_lines = "gks"
vim.g.sort_motion_visual = "gk"

vim.g.openbrowser_github_always_use_commit_hash = 1
vim.g.openbrowser_github_always_used_branch = 0
vim.g.openbrowser_github_select_current_line = 0
vim.g.openbrowser_github_url_exists_check = 0

vim.g.codeium_disable_bindings = 1
vim.g.codeium_no_map_tab = 1
vim.g.codeium_idle_delay = 10
vim.g.codeium_render = 1

vim.g.autoformat = true

vim.g.lazyvim_python_lsp = "basedpyright"

vim.o.exrc = true
vim.o.spellfile = vim.fn.expand("$HOME/Documents/.vimspell.en.add")

vim.o.splitkeep = "screen"

vim.lsp.set_log_level("WARN")

vim.opt.iskeyword:remove("(")
vim.opt.iskeyword:remove(")")
