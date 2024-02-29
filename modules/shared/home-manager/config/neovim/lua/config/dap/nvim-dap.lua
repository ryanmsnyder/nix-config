-- find the python executable that was installed and exposed by Nix, which also has debugpy installed as a package
if vim.fn.executable("python") then
	require("dap-python").setup(vim.fn.exepath("python"))
end
