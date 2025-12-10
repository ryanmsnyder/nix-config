_G.prequire = function(plugin, verbose)
	local present, plug = pcall(require, plugin)
	if present then
		return plug
	end
	local errmsg = string.format("Could not load %s", plugin)
	if verbose then
		errmsg = string.format("%s\nError:%s", plug)
	end
	print(errmsg)
end

local M = {}

function M.termcodes(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- function M.map(modes, lhs, rhs, opts)
-- 	if type(opts) == "string" then
-- 		opts = { desc = opts }
-- 	end
-- 	local options = vim.tbl_extend("keep", opts or {}, { silent = true })
-- 	vim.keymap.set(modes, lhs, rhs, options)
-- end

function M.feedkeys(keys, mode)
	if mode == nil then
		mode = "in"
	end
	return vim.api.nvim_feedkeys(M.termcodes(keys), mode, true)
end

function M.feedkeys_count(keys, mode)
	return M.feedkeys(vim.v.count1 .. keys, mode)
end

function M.setSpacesSize(filetypes)
	for filetype, size in pairs(filetypes) do
		vim.cmd(string.format("autocmd FileType %s set sw=%s", filetype, size))
		vim.cmd(string.format("autocmd FileType %s set ts=%s", filetype, size))
		vim.cmd(string.format("autocmd FileType %s set sts=%s", filetype, size))
	end
end

M.diagnostics_active = true

function M.toggle_diagnostics()
	M.diagnostics_active = not M.diagnostics_active
	if M.diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

--- Gets the buffer number of every visible buffer
--- @return integer[]
function M.visible_buffers()
	return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
end

local function lsp_server_has_references()
	return vim.tbl_contains(vim.lsp.get_clients(), function(client)
		local capabilities = client.server_capabilities
		return capabilities and capabilities.referencesProvider
	end, { predicate = true })
end

--- Clear all highlighted LSP references in all windows
function M.clear_lsp_references()
	vim.cmd.nohlsearch()
	if lsp_server_has_references() then
		vim.lsp.buf.clear_references()
		for _, buffer in pairs(M.visible_buffers()) do
			vim.lsp.util.buf_clear_references(buffer)
		end
	end
end

-- Close every floating window
function M.close_floating_windows()
	for _, win in pairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative == "win" then
			vim.api.nvim_win_close(win, false)
		end
	end
end

function M.try(fn, ...)
	local args = { ... }

	return xpcall(function()
		---@diagnostic disable-next-line: deprecated
		return fn(unpack(args))
	end, function(err)
		local lines = {}
		table.insert(lines, err)
		table.insert(lines, debug.traceback("", 3))

		M.error(table.concat(lines, "\n"))
		return err
	end)
end

function M.require(mod)
	local ok, ret = M.try(require, mod)
	return ok and ret
end

function M.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name or "init.lua" })
end

function M.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name or "init.lua" })
end

function M.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name or "init.lua" })
end

function M.lazygit_toggle()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "double",
		},
	})

	lazygit:toggle()
end

return M
