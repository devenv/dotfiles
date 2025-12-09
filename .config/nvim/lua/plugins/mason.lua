local plugins = {
  {
    "mason-org/mason.nvim",
    lazy = true,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      -- Don't block exit while installing packages
      ui = {
        check_outdated_packages_on_open = false,
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- Only auto-configure these servers when mason-lspconfig loads
      automatic_installation = false,
      handlers = {
        ruff = function()
          require("lspconfig").ruff.setup({
            cmd = { "/opt/homebrew/bin/ruff", "server" },
            settings = {
              ruff = {
                ignore = {},
              },
            },
          })
        end,
      },
    },
  },
}

return plugins