-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

function _G.open_git_branch_in_browser()
  local branch_handle = io.popen("git rev-parse --abbrev-ref HEAD")
  local result = branch_handle:read("*a")
  branch_handle:close()
  local url_handle = io.popen('git config --get remote.origin.url | sed "s|git@||;s|.com:|.com/|;s|\\.git||"')
  local url = url_handle:read("*a")
  url_handle:close()
  local branch_name = result:gsub("%s+", "") -- to remove newline character at the end
  local url_replaced = url:gsub("%s+", "")
  vim.cmd("OpenBrowser " .. url_replaced .. "/pull/new/" .. branch_name)
end

P = function(v)
  print(vim.inspect(v))
  return v
end
