-- LSP-powered breadcrumbs for better code navigation
return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      return {
        separator = "  ",
        highlight = true,
        depth_limit = 5,
        icons = {
          Array = "🔢 ",
          Boolean = "🔘 ",
          Class = "🏗️ ",
          Constructor = "🔨 ",
          Enum = "📋 ",
          EnumMember = "📄 ",
          Event = "⚡ ",
          Field = "🏷️ ",
          File = "📁 ",
          Function = "⚙️ ",
          Interface = "🔌 ",
          Key = "🗝️ ",
          Method = "🔧 ",
          Module = "📦 ",
          Namespace = "📂 ",
          Null = "⭕ ",
          Number = "🔢 ",
          Object = "📊 ",
          Operator = "➕ ",
          Package = "📦 ",
          Property = "🏷️ ",
          String = "💬 ",
          Struct = "🏛️ ",
          TypeParameter = "🔤 ",
          Variable = "💎 ",
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        click = true,
        format_text = function(text)
          -- Add Python-specific file icon
          local current_file = vim.fn.expand("%:t")
          if current_file:match("%.py$") then
            -- Replace the generic file icon with Python snake emoji for .py files
            text = text:gsub("📁 ([^%s]+%.py)", "🐍 %1")
          end
          return text
        end,
      }
    end,
    config = function(_, opts)
      require("nvim-navic").setup(opts)
      
      -- Set up beautiful catppuccin colors for navic
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "catppuccin" then
            local cp = require("catppuccin.palettes").get_palette("mocha")
            
            -- Define navic highlight groups with catppuccin colors
            local navic_highlights = {
              -- File and path elements (subdued colors)
              NavicIconsFile = { fg = cp.overlay2 },
              NavicIconsModule = { fg = cp.overlay2 },
              NavicIconsNamespace = { fg = cp.overlay2 },
              NavicIconsPackage = { fg = cp.overlay2 },
              
              -- Code structure elements (prominent colors)
              NavicIconsClass = { fg = cp.mauve, bold = true },
              NavicIconsMethod = { fg = cp.sapphire, bold = true },
              NavicIconsFunction = { fg = cp.blue, bold = true },
              NavicIconsConstructor = { fg = cp.red, bold = true },
              
              -- Data elements (medium prominence)
              NavicIconsVariable = { fg = cp.lavender },
              NavicIconsProperty = { fg = cp.flamingo },
              NavicIconsField = { fg = cp.rosewater },
              NavicIconsConstant = { fg = cp.peach },
              
              -- Type elements
              NavicIconsInterface = { fg = cp.sky },
              NavicIconsEnum = { fg = cp.maroon },
              NavicIconsStruct = { fg = cp.teal },
              NavicIconsTypeParameter = { fg = cp.yellow },
              
              -- Data types
              NavicIconsString = { fg = cp.green },
              NavicIconsNumber = { fg = cp.peach },
              NavicIconsBoolean = { fg = cp.sky },
              NavicIconsArray = { fg = cp.yellow },
              NavicIconsObject = { fg = cp.pink },
              NavicIconsKey = { fg = cp.red },
              NavicIconsNull = { fg = cp.overlay1 },
              NavicIconsEnumMember = { fg = cp.teal },
              NavicIconsEvent = { fg = cp.flamingo },
              NavicIconsOperator = { fg = cp.sky },
              
              -- Text highlights with hierarchy
              NavicText = { fg = cp.overlay2 }, -- Subdued for file paths
              NavicSeparator = { fg = cp.overlay0 },
            }
            
            -- Apply the highlights
            for group, colors in pairs(navic_highlights) do
              vim.api.nvim_set_hl(0, group, colors)
            end
          end
        end,
      })
      
      -- Trigger the highlight setup immediately if catppuccin is already loaded
      if vim.g.colors_name == "catppuccin" then
        vim.cmd("doautocmd ColorScheme")
      end
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      ---Whether to attach navic to language servers automatically.
      ---
      ---@type boolean
      attach_navic = true,
      
      ---Whether to create winbar updater autocmd.
      ---
      ---@type boolean
      create_autocmd = true,
      
      ---Buftypes to enable winbar in.
      ---
      ---@type string[]
      include_buftypes = { "" },
      
      ---Filetypes not to enable winbar in.
      ---
      ---@type string[]
      exclude_filetypes = { "netrw", "toggleterm", "NvimTree", "neo-tree", "dapui_watches", "dapui_breakpoints", "dapui_scopes", "dapui_console", "dapui_stacks", "dap-repl" },
      
      modifiers = {
        ---Filename modifiers applied to dirname.
        ---
        ---See: `:help filename-modifiers`
        ---
        ---@type string
        dirname = ":~:.",
        
        ---Filename modifiers applied to basename.
        ---
        ---See: `:help filename-modifiers`
        ---
        ---@type string
        basename = "",
      },
      
      ---Whether to display path to file.
      ---
      ---@type boolean
      show_dirname = true,
      
      ---Whether to display file name.
      ---
      ---@type boolean
      show_basename = true,
      
      ---Whether to replace file icon with the modified symbol when buffer is
      ---modified.
      ---
      ---@type boolean
      show_modified = false,
      
      ---Get modified status of file.
      ---
      ---NOTE: This can be used to get file modified status from SCM (e.g. git)
      ---
      ---@type fun(bufnr: number): boolean
      modified = function(bufnr)
        return vim.bo[bufnr].modified
      end,
      
      ---Whether to show/use navic in the winbar.
      ---
      ---@type boolean
      show_navic = true,
      
      ---Get leading custom section contents.
      ---
      ---NOTE: This function shouldn't do any expensive actions as it is run on each
      ---render.
      ---
      ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
      lead_custom_section = function(bufnr)
        return "" -- Remove the leading file icon
      end,
      
      ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
      custom_section = function(bufnr)
        return "" -- Remove the duplicate filename section
      end,
      
      ---Whether context text should follow its icon's color.
      ---
      ---@type boolean
      context_follow_icon_color = false,
      
      symbols = {
        ---Modification indicator.
        ---
        ---@type string
        modified = "●",
        
        ---Truncation indicator.
        ---
        ---@type string
        ellipsis = "…",
        
        ---Entry separator.
        ---
        ---@type string
        separator = "/",
      },
      
      ---icons for different context entry kinds.
      ---`false` to disable kind icons.
      ---
      ---@type table<string, string> | false
      kinds = {
        Array = "🔢",
        Boolean = "🔘",
        Class = "🏗️",
        Constructor = "🔨",
        Enum = "📋",
        EnumMember = "📄",
        Event = "⚡",
        Field = "🏷️",
        File = "🐍", -- Default to Python, will be dynamically updated
        Function = "⚙️",
        Interface = "🔌",
        Key = "🗝️",
        Method = "🔧",
        Module = "📦",
        Namespace = "📂",
        Null = "⭕",
        Number = "🔢",
        Object = "📊",
        Operator = "➕",
        Package = "📦",
        Property = "🏷️",
        String = "💬",
        Struct = "🏛️",
        TypeParameter = "🔤",
        Variable = "💎",
      },
    },
    config = function(_, opts)
      require("barbecue").setup(opts)
      
      -- Function to update file icon based on current file type
      local function update_file_icon()
        local filename = vim.fn.expand("%:t")
        local icon = "📁" -- default
        
        if filename:match("%.py$") then
          icon = "🐍"
        elseif filename:match("%.js$") or filename:match("%.ts$") then
          icon = "🟨"
        elseif filename:match("%.jsx$") or filename:match("%.tsx$") then
          icon = "⚛️"
        elseif filename:match("%.json$") then
          icon = "📋"
        elseif filename:match("%.md$") then
          icon = "📝"
        elseif filename:match("%.lua$") then
          icon = "🌙"
        elseif filename:match("%.go$") then
          icon = "🐹"
        elseif filename:match("%.rs$") then
          icon = "🦀"
        elseif filename:match("%.toml$") or filename:match("%.yaml$") or filename:match("%.yml$") then
          icon = "⚙️"
        end
        
        -- Update the barbecue config dynamically
        require("barbecue.config").user.kinds.File = icon
      end
      
      -- Update file icon when entering a buffer
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        callback = update_file_icon,
      })
      
      -- Update immediately for current buffer
      update_file_icon()
      
      -- Set up highlights to work well with catppuccin
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
                      -- Get catppuccin colors if available
            local colors = {}
            if vim.g.colors_name == "catppuccin" then
              local cp = require("catppuccin.palettes").get_palette()
              colors = {
                -- Basic elements
                normal = cp.overlay2, -- Subdued for file paths
                ellipsis = cp.overlay1,
                separator = cp.overlay0,
                modified = cp.peach,
                dirname = cp.overlay2, -- Subdued directory names
                basename = cp.overlay2, -- Subdued file names
                
                -- Context elements with hierarchy
                context = cp.overlay2, -- Default context (subdued)
                context_file = cp.overlay2, -- File context (subdued)
                context_module = cp.overlay2, -- Module context (subdued)
                context_namespace = cp.overlay2, -- Namespace context (subdued)
                context_package = cp.overlay2, -- Package context (subdued)
                
                -- Code structure (prominent)
                context_class = cp.mauve, -- Bright purple for classes
                context_method = cp.sapphire, -- Bright blue for methods
                context_function = cp.blue, -- Blue for functions
                context_constructor = cp.red, -- Red for constructors
                
                -- Data elements (medium prominence)
                context_variable = cp.lavender, -- Light purple for variables
                context_property = cp.flamingo, -- Pink for properties
                context_field = cp.rosewater, -- Light pink for fields
                context_constant = cp.peach, -- Orange for constants
                
                -- Type elements
                context_interface = cp.sky,
                context_enum = cp.maroon,
                context_struct = cp.teal,
                context_type_parameter = cp.yellow,
                
                -- Data types
                context_string = cp.green,
                context_number = cp.peach,
                context_boolean = cp.sky,
                context_array = cp.yellow,
                context_object = cp.pink,
                context_key = cp.red,
                context_null = cp.overlay1,
                context_enum_member = cp.teal,
                context_event = cp.flamingo,
                context_operator = cp.sky,
              }
            
            -- Apply the colors
            for name, color in pairs(colors) do
              vim.api.nvim_set_hl(0, "Barbecue" .. name:gsub("^%l", string.upper):gsub("_(%l)", function(c) return string.upper(c) end), { fg = color })
            end
          end
        end,
      })
    end,
  },
}