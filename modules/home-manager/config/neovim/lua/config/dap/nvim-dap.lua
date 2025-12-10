if vim.fn.executable("python") then
	-- This is intended to be used alongside a devShell that installs debugpy. Installing debugpy in neovim extraPackages doesn't allow for dynamically passing the path to a python install that has debugpy. Since I want to use a devShell and manage dependecies with poetry or pip, vim.fn.exepath("python") will return the path of the local .venv since it will be activated when entering the shell. Therefore, it's best to just install debugpy as part of the devShell. The python devShells can be found in templates/.
	require("dap-python").setup(vim.fn.exepath("python"))

	-- Define a list of debug configurations
	local configurations = {
		{
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Python: Launch main.py (all code)",
			program = "main.py", -- This configuration will launch the current file if used.
			justMyCode = false,
			pythonPath = ".venv/bin/python",
			console = "integratedTerminal", -- output to dapui console instead of repl
		},

		{
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Python: Launch main.py (my code only)",
			program = "main.py", -- This configuration will launch the current file if used.
			justMyCode = true,
			pythonPath = ".venv/bin/python",
			console = "integratedTerminal", -- output to dapui console instead of repl
		},

		{
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Python: Launch current file (all code)",
			program = "${file}", -- This configuration will launch the current file if used.
			justMyCode = false,
			pythonPath = ".venv/bin/python",
			console = "integratedTerminal", -- output to dapui console instead of repl
		},

		{
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Python: Launch current file (my code only)",
			program = "${file}", -- This configuration will launch the current file if used.
			justMyCode = true,
			pythonPath = ".venv/bin/python",
			console = "integratedTerminal", -- output to dapui console instead of repl
		},
	}

	require("dap").configurations.python = configurations
end

-- DAP sign definitions
local icons = require("icons.icons")
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = icons.Circle, texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = icons.Circle, texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = icons.DapLogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })
