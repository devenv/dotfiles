-- Neotest configuration for better test management
-- Replaces the custom pytest integration with a more robust solution

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      -- Optional: for better terminal integration
      "akinsho/toggleterm.nvim",
      -- Optional: for notifications
      "rcarriga/nvim-notify",
    },
    config = function()
      local neotest = require("neotest")
      
      -- Get the appropriate python executable for the current project
      local function get_python_cmd()
        local cwd = vim.fn.getcwd()
        
        -- Try nilus service first (handles both root and src/ subdirectory)
        if string.match(cwd, "/nilus/core/services/") then
          local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
          if not service_match then
            -- Check if we're in src/ subdirectory
            service_match = string.match(cwd, "/nilus/core/services/([^/]+)/src")
          end
          if service_match then
            local python_path = "/Users/devenv/nilus/core/services/" .. service_match .. "/venv/bin/python"
            if vim.fn.executable(python_path) == 1 then
              return python_path
            end
          end
        end
        
        -- Try virtual environment
        local venv_paths = { "venv/bin/python", ".venv/bin/python", "../venv/bin/python" }
        for _, path in ipairs(venv_paths) do
          local full_path = cwd .. "/" .. path
          if vim.fn.executable(full_path) == 1 then
            return full_path
          end
        end
        
        -- Fallback to system python
        return "python"
      end

      -- Get environment configuration for the current project
      local function get_env_config()
        local cwd = vim.fn.getcwd()
        
        -- Check if we're in any nilus service directory (handles both root and src/ subdirectory)
        if string.match(cwd, "/nilus/core/services/") then
          local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
          if not service_match then
            service_match = string.match(cwd, "/nilus/core/services/([^/]+)/src")
          end
          if service_match then
            local src_path = "/Users/devenv/nilus/core/services/" .. service_match .. "/src"
            if vim.fn.isdirectory(src_path) == 1 then
              return {
                PYTHONPATH = src_path,
                working_dir = src_path,
              }
            end
          end
        end
        
        return { working_dir = cwd }
      end

      neotest.setup({
        adapters = {
          require("neotest-python")({
            -- Dynamic python path detection
            python = function()
              return get_python_cmd()
            end,
            -- Arguments to pass to pytest
            args = { "-v", "-s" },
            -- Environment variables
            env = function()
              local env_config = get_env_config()
              local env = {}
              if env_config.PYTHONPATH then
                env.PYTHONPATH = env_config.PYTHONPATH
              end
              return env
            end,
            -- Working directory
            cwd = function()
              local env_config = get_env_config()
              return env_config.working_dir
            end,
            -- Runner (pytest is default, but we can specify)
            runner = "pytest",
            -- Test discovery patterns
            is_test_file = function(file_path)
              return vim.endswith(file_path, "test_.py") or 
                     vim.endswith(file_path, "_test.py") or
                     string.match(file_path, "test_.*%.py$") or
                     string.match(file_path, ".*_test%.py$")
            end,
          }),
        },
        -- Output configuration
        output = {
          enabled = true,
          open_on_run = "short", -- "short", "long", "never"
        },
        -- Quickfix list integration
        quickfix = {
          enabled = true,
          open = false, -- Don't auto-open quickfix
        },
        -- Status configuration
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        -- Icons for test status
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✓",
          running = "●",
          running_animated = { "◐", "◓", "◑", "◒" },
          skipped = "○",
          unknown = "?"
        },
        -- Floating window configuration
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.8,
          options = {}
        },
        -- Summary window configuration
        summary = {
          enabled = true,
          animated = true,
          follow = true,
          expand_errors = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        -- Discovery configuration
        discovery = {
          enabled = true,
          concurrent = 1, -- Number of workers for discovery
        },
        -- Running configuration
        running = {
          concurrent = true,
        },
        -- Strategies for different output types
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        -- Projects configuration (can be used for project-specific settings)
        projects = {},
        -- Log level for debugging neotest issues
        log_level = vim.log.levels.WARN,
      })

      -- Set up key mappings
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Test execution mappings (mirroring the previous pytest keymaps)
      map("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
      map("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current test file" })
      map("n", "<leader>t<tab>", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run all tests" })
      map("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run last test" })
      map("n", "<leader>ts", function() neotest.run.stop() end, { desc = "Stop running tests" })
      
      -- Debug mappings
      map("n", "<leader>tF", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug nearest test" })
      map("n", "<leader>dt", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug nearest test" })
      
      -- UI and information mappings (update to avoid conflicts)
      map("n", "<leader>tw", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
      map("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Open test output" })
      map("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
      
      -- Navigation mappings
      map("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Jump to next failed test" })
      map("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Jump to prev failed test" })
      
      -- Watch mode (continuous testing) - use different key to avoid conflict
      map("n", "<leader>tW", function() neotest.watch.toggle() end, { desc = "Toggle watch mode" })
      
      -- Attach to running process (for debugging)
      map("n", "<leader>ta", function() neotest.run.attach() end, { desc = "Attach to running test" })

      -- Create user commands for convenience
      vim.api.nvim_create_user_command("NeotestRun", function() neotest.run.run() end, { desc = "Run nearest test" })
      vim.api.nvim_create_user_command("NeotestFile", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current test file" })
      vim.api.nvim_create_user_command("NeotestAll", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run all tests" })
      vim.api.nvim_create_user_command("NeotestLast", function() neotest.run.run_last() end, { desc = "Run last test" })
      vim.api.nvim_create_user_command("NeotestStop", function() neotest.run.stop() end, { desc = "Stop running tests" })
      vim.api.nvim_create_user_command("NeotestDebug", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug nearest test" })
      vim.api.nvim_create_user_command("NeotestSummary", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
      vim.api.nvim_create_user_command("NeotestOutput", function() neotest.output.open({ enter = true }) end, { desc = "Open test output" })
      vim.api.nvim_create_user_command("NeotestPanel", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
      vim.api.nvim_create_user_command("NeotestWatch", function() neotest.watch.toggle() end, { desc = "Toggle watch mode" })
      vim.api.nvim_create_user_command("NeotestAttach", function() neotest.run.attach() end, { desc = "Attach to running test" })

      -- Auto-open summary when tests are run (optional)
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeotestRunStarted",
        callback = function()
          -- Optionally open summary when tests start
          -- neotest.summary.open()
        end,
      })

      -- Notification integration if nvim-notify is available
      local notify_ok, notify = pcall(require, "notify")
      if notify_ok then
        vim.api.nvim_create_autocmd("User", {
          pattern = "NeotestRunFinished",
          callback = function()
            local results = neotest.state.get_results()
            local passed = 0
            local failed = 0
            local skipped = 0
            
            for _, result in pairs(results) do
              if result.status == "passed" then
                passed = passed + 1
              elseif result.status == "failed" then
                failed = failed + 1
              elseif result.status == "skipped" then
                skipped = skipped + 1
              end
            end
            
            local total = passed + failed + skipped
            if total > 0 then
              local message = string.format("✓ %d  ✖ %d  ○ %d", passed, failed, skipped)
              local level = failed > 0 and "warn" or "info"
              notify(message, level, {
                title = "Tests Completed",
                timeout = 3000,
                render = "minimal",
              })
            end
          end,
        })
      end
    end,
    keys = {
      -- Add key definitions here for lazy loading
      { "<leader>tt", desc = "Run nearest test" },
      { "<leader>tf", desc = "Run current test file" },
      { "<leader>t<tab>", desc = "Run all tests" },
      { "<leader>tl", desc = "Run last test" },
      { "<leader>ts", desc = "Stop running tests" },
      { "<leader>tF", desc = "Debug nearest test" },
      { "<leader>dt", desc = "Debug nearest test" },
      { "<leader>tw", desc = "Toggle test summary" },
      { "<leader>to", desc = "Open test output" },
      { "<leader>tO", desc = "Toggle output panel" },
      { "]t", desc = "Jump to next failed test" },
      { "[t", desc = "Jump to prev failed test" },
      { "<leader>ta", desc = "Attach to running test" },
    },
  },
  -- Keep the existing dependencies for better integration
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("notify").setup({
        stages = "fade",
        timeout = 2000,
        max_height = function()
          return math.floor(vim.o.lines * 0.3)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.4)
        end,
        render = "compact",
        background_colour = "#1a1a1a",
        top_down = false,
        minimum_width = 50,
        wrap = true,
        level = 2,
        fps = 60,
        icons = {
          ERROR = "✘",
          WARN = "▲",
          INFO = "●",
          DEBUG = "⚙",
          TRACE = "✎",
        },
      })
      vim.notify = require("notify")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = false,
        shell = vim.o.shell,
      })
    end,
  },
}
