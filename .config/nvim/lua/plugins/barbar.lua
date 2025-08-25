-- Replace bufferline.nvim with barbar.nvim for better stability and catppuccin integration
return {
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- Enable animations
      animation = true,
      
      -- Enable/disable auto-hiding the tab bar when there is a single buffer
      auto_hide = false,
      
      -- Enable/disable current/total tabpages indicator (top right corner)
      tabpages = true,
      
      -- Enables/disable clickable tabs
      --  - left-click: go to buffer
      --  - middle-click: delete buffer
      clickable = true,
      
      -- Excludes buffers from the tabline
      exclude_ft = {'javascript'},
      exclude_name = {'package.json'},
      
      -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
      -- Valid options are 'left' (the default), 'previous', and 'right'
      focus_on_close = 'left',
      
      -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`
      hide = {extensions = true, inactive = false},
      
      -- Disable highlighting alternate buffers
      highlight_alternate = false,
      
      -- Disable highlighting file icons in inactive buffers
      highlight_inactive_file_icons = false,
      
      -- Enable highlighting visible buffers
      highlight_visible = true,
      
      icons = {
        -- Configure the base icons on the bufferline.
        buffer_index = false,
        buffer_number = false,
        button = '',
        -- Enables / disables diagnostic symbols
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ''},
          [vim.diagnostic.severity.WARN] = {enabled = true, icon = ''},
          [vim.diagnostic.severity.INFO] = {enabled = false},
          [vim.diagnostic.severity.HINT] = {enabled = true, icon = ''},
        },
        gitsigns = {
          added = {enabled = true, icon = '+'},
          changed = {enabled = true, icon = '~'},
          deleted = {enabled = true, icon = '-'},
        },
        filetype = {
          -- Sets the icon's highlight group.
          custom_colors = false,
          -- Requires `nvim-web-devicons` if `true`
          enabled = true,
        },
        separator = {left = '▎', right = ''},
        -- Configure the icons on the bufferline when modified or pinned.
        modified = {button = '●'},
        pinned = {button = '', filename = true},
        -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
        preset = 'default',
        -- Configure the icons on the bufferline based on the visibility of a buffer.
        alternate = {filetype = {enabled = false}},
        current = {buffer_index = true},
        inactive = {button = '×'},
        visible = {modified = {buffer_number = false}},
      },
      
      -- If true, new buffers will be inserted at the start/end of the list.
      insert_at_end = false,
      insert_at_start = false,
      
      -- Sets the maximum padding width with which to surround each tab
      maximum_padding = 1,
      
      -- Sets the minimum padding width with which to surround each tab  
      minimum_padding = 1,
      
      -- Sets the maximum buffer name length.
      maximum_length = 30,
      
      -- If set, the letters for each buffer in buffer-pick mode will be
      -- assigned based on their name. Otherwise or in case all letters are
      -- already assigned, the behavior is to assign letters in order of
      -- usability (see order below)
      semantic_letters = true,
      
      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = true,
        -- Or, specify the text used for the offset:
        undotree = {
          text = 'undotree',
          align = 'center', -- *optionally* specify an alignment (either 'left', 'center', or 'right')
        },
        -- Or, specify the event which the sidebar executes when leaving:
        ['neo-tree'] = {event = 'BufWipeout'},
        -- Or, specify both
        Outline = {event = 'BufWinLeave', text = 'symbols-outline', align = 'right'},
      },
      
      -- New buffer letters are assigned in this order. This order is
      -- optimal for the qwerty keyboard layout but might need adjustment
      -- for other layouts.
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      
      -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
      -- where X is the buffer number. But only a static string is accepted here.
      no_name_title = nil,
    },
    config = function(_, opts)
      require('barbar').setup(opts)
      
      -- Set up beautiful catppuccin colors for barbar
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "catppuccin" then
            local cp = require("catppuccin.palettes").get_palette("mocha")
            
            -- Define barbar highlight groups with catppuccin colors
            local barbar_highlights = {
              -- Buffer backgrounds
              BufferCurrent = { fg = cp.text, bg = cp.base },
              BufferCurrentIndex = { fg = cp.text, bg = cp.base },
              BufferCurrentMod = { fg = cp.peach, bg = cp.base },
              BufferCurrentSign = { fg = cp.blue, bg = cp.base },
              BufferCurrentTarget = { fg = cp.red, bg = cp.base },
              
              -- Visible buffers (in other windows)
              BufferVisible = { fg = cp.overlay2, bg = cp.mantle },
              BufferVisibleIndex = { fg = cp.overlay2, bg = cp.mantle },
              BufferVisibleMod = { fg = cp.peach, bg = cp.mantle },
              BufferVisibleSign = { fg = cp.overlay1, bg = cp.mantle },
              BufferVisibleTarget = { fg = cp.red, bg = cp.mantle },
              
              -- Inactive buffers
              BufferInactive = { fg = cp.overlay1, bg = cp.crust },
              BufferInactiveIndex = { fg = cp.overlay1, bg = cp.crust },
              BufferInactiveMod = { fg = cp.peach, bg = cp.crust },
              BufferInactiveSign = { fg = cp.surface1, bg = cp.crust },
              BufferInactiveTarget = { fg = cp.red, bg = cp.crust },
              
              -- Tabline fill
              BufferTabpages = { fg = cp.overlay1, bg = cp.crust },
              BufferTabpageFill = { fg = cp.overlay1, bg = cp.crust },
              
              -- Diagnostic highlights with proper backgrounds
              BufferCurrentERROR = { fg = cp.red, bg = cp.base, bold = true },
              BufferCurrentWARN = { fg = cp.yellow, bg = cp.base, bold = true },
              BufferCurrentINFO = { fg = cp.sky, bg = cp.base },
              BufferCurrentHINT = { fg = cp.teal, bg = cp.base },
              
              BufferVisibleERROR = { fg = cp.red, bg = cp.mantle, bold = true },
              BufferVisibleWARN = { fg = cp.yellow, bg = cp.mantle, bold = true },
              BufferVisibleINFO = { fg = cp.sky, bg = cp.mantle },
              BufferVisibleHINT = { fg = cp.teal, bg = cp.mantle },
              
              BufferInactiveERROR = { fg = cp.red, bg = cp.crust, bold = true },
              BufferInactiveWARN = { fg = cp.yellow, bg = cp.crust, bold = true },
              BufferInactiveINFO = { fg = cp.sky, bg = cp.crust },
              BufferInactiveHINT = { fg = cp.teal, bg = cp.crust },
              
              -- Additional diagnostic highlight groups that might be used
              BufferCurrentDiagnosticError = { fg = cp.red, bg = cp.base, bold = true },
              BufferCurrentDiagnosticWarn = { fg = cp.yellow, bg = cp.base, bold = true },
              BufferCurrentDiagnosticInfo = { fg = cp.sky, bg = cp.base },
              BufferCurrentDiagnosticHint = { fg = cp.teal, bg = cp.base },
              
              BufferVisibleDiagnosticError = { fg = cp.red, bg = cp.mantle, bold = true },
              BufferVisibleDiagnosticWarn = { fg = cp.yellow, bg = cp.mantle, bold = true },
              BufferVisibleDiagnosticInfo = { fg = cp.sky, bg = cp.mantle },
              BufferVisibleDiagnosticHint = { fg = cp.teal, bg = cp.mantle },
              
              BufferInactiveDiagnosticError = { fg = cp.red, bg = cp.crust, bold = true },
              BufferInactiveDiagnosticWarn = { fg = cp.yellow, bg = cp.crust, bold = true },
              BufferInactiveDiagnosticInfo = { fg = cp.sky, bg = cp.crust },
              BufferInactiveDiagnosticHint = { fg = cp.teal, bg = cp.crust },
              
              -- Alternative buffer (last accessed)
              BufferAlternate = { fg = cp.overlay2, bg = cp.surface0 },
              BufferAlternateIndex = { fg = cp.overlay2, bg = cp.surface0 },
              BufferAlternateMod = { fg = cp.peach, bg = cp.surface0 },
              BufferAlternateSign = { fg = cp.overlay1, bg = cp.surface0 },
              BufferAlternateTarget = { fg = cp.red, bg = cp.surface0 },
            }
            
            -- Apply the highlights
            for group, colors in pairs(barbar_highlights) do
              vim.api.nvim_set_hl(0, group, colors)
            end
          end
        end,
      })
      
      -- Trigger the highlight setup immediately if catppuccin is already loaded
      if vim.g.colors_name == "catppuccin" then
        vim.cmd("doautocmd ColorScheme")
      end
      
      -- Additional fix for diagnostic backgrounds - run after everything loads
      vim.defer_fn(function()
        if vim.g.colors_name == "catppuccin" then
          local cp = require("catppuccin.palettes").get_palette("mocha")
          
          -- Force override any black backgrounds on diagnostic highlights
          local diagnostic_fixes = {
            BufferCurrentERROR = { fg = cp.red, bg = cp.base, bold = true },
            BufferCurrentWARN = { fg = cp.yellow, bg = cp.base, bold = true },
            BufferVisibleERROR = { fg = cp.red, bg = cp.mantle, bold = true },
            BufferVisibleWARN = { fg = cp.yellow, bg = cp.mantle, bold = true },
            BufferInactiveERROR = { fg = cp.red, bg = cp.crust, bold = true },
            BufferInactiveWARN = { fg = cp.yellow, bg = cp.crust, bold = true },
            
            -- Also try these alternative names
            ["BufferCurrent ERROR"] = { fg = cp.red, bg = cp.base, bold = true },
            ["BufferCurrent WARN"] = { fg = cp.yellow, bg = cp.base, bold = true },
            ["BufferVisible ERROR"] = { fg = cp.red, bg = cp.mantle, bold = true },
            ["BufferVisible WARN"] = { fg = cp.yellow, bg = cp.mantle, bold = true },
            ["BufferInactive ERROR"] = { fg = cp.red, bg = cp.crust, bold = true },
            ["BufferInactive WARN"] = { fg = cp.yellow, bg = cp.crust, bold = true },
          }
          
          for group, colors in pairs(diagnostic_fixes) do
            vim.api.nvim_set_hl(0, group, colors)
          end
        end
      end, 100) -- Wait 100ms for everything to load
      
      -- Set up key mappings for barbar
      local map = vim.api.nvim_set_keymap
      local opts_keymap = { noremap = true, silent = true }
      
      -- Move to previous/next
      map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts_keymap)
      map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts_keymap)
      -- Re-order to previous/next
      map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts_keymap)
      map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts_keymap)
      -- Goto buffer in position...
      map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts_keymap)
      map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts_keymap)
      map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts_keymap)
      map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts_keymap)
      map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts_keymap)
      map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts_keymap)
      map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts_keymap)
      map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts_keymap)
      map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts_keymap)
      map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts_keymap)
      -- Pin/unpin buffer
      map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts_keymap)
      -- Close buffer
      map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts_keymap)
      -- Buffer pick mode
      map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts_keymap)
    end,
  },
}