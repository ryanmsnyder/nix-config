-- find the python executable that was installed and exposed by Nix, which also has debugpy installed as a package
if vim.fn.executable("python") then
	require("dap-python").setup(vim.fn.exepath("python"))

	-- Define a list of debug configurations
	local configurations = {
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

	-- require("dap").configurations.python = configurations
end
