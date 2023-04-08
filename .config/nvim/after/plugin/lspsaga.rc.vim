lua << EOF
require("lspsaga").setup{
  beacon = {
    enable = false,
    frequency = 1,
  },
  symbol_in_winbar = {
    enable = false,
  }
}
EOF
