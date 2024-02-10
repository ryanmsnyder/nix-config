local mason_nvim_dap = require "mason-nvim-dap"
if not mason_nvim_dap then
  return
end

mason_nvim_dap.setup {
  ensure_installed = {
    "python", -- installs debugpy
    "node2",
  },
  automatic_installation = true,
  handlers = { -- Instead of configurations
    function(config)
      -- all sources with no handler get passed here

      -- Keep original functionality
      require("mason-nvim-dap").default_setup(config)
    end,
    -- override default python handler
    python = function(config)
      config.configurations = {
        {
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Python: Launch main.py (all code)",
          program = "main.py", -- This configuration will launch the current file if used.
          justMyCode = false,
          pythonPath = "venv/bin/python",
          console = "integratedTerminal", -- output to dapui console instead of repl
        },

        {
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Python: Launch main.py (my code only)",
          program = "main.py", -- This configuration will launch the current file if used.
          justMyCode = true,
          pythonPath = "venv/bin/python",
          console = "integratedTerminal", -- output to dapui console instead of repl
        },

        {
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Python: Launch current file (all code)",
          program = "${file}", -- This configuration will launch the current file if used.
          justMyCode = false,
          pythonPath = "venv/bin/python",
          console = "integratedTerminal", -- output to dapui console instead of repl
        },

        {
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Python: Launch current file (my code only)",
          program = "${file}", -- This configuration will launch the current file if used.
          justMyCode = true,
          pythonPath = "venv/bin/python",
          console = "integratedTerminal", -- output to dapui console instead of repl
        },
      }
      require("mason-nvim-dap").default_setup(config) -- don't forget this!
    end,

    node2 = function(config)
      config.configurations = {
        {
          type = "node2",
          request = "launch",
          name = "Launch Program",
          skipFiles = { "<node_internals>/**" },
          program = "${file}",
          console = "integratedTerminal", -- output to dapui console instead of repl
        },
      }
      require("mason-nvim-dap").default_setup(config) -- don't forget this!
    end,
  },
}
