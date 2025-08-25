-- Configure Python provider to use dedicated virtualenv
-- This helps avoid the virtualenv optimization warning
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Set python3_host_prog to use the updated pynvim installation
      vim.g.python3_host_prog = "/Users/devenv/.pyenv/versions/3.10.5/bin/python"
      return opts
    end,
  },
}