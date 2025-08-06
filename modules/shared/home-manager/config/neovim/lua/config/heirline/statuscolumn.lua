local M = {}

-- Utility function to extend tables (similar to heirline-components utils)
local function extend_tbl(default, opts)
	opts = opts or {}
	return default and vim.tbl_deep_extend("force", default, opts) or opts
end

-- Utility function to stylize strings (simplified version from heirline-components)
local function stylize(str, opts)
	opts = extend_tbl({ escape = false }, opts)
	if not str or str == "" then
		return ""
	end
	return opts.escape and str:gsub("%%", "%%%%") or str
end

-- Condition function to check if signcolumn is enabled
local function signcolumn_enabled()
	return vim.opt.signcolumn:get() ~= "no"
end

-- Condition function to check if numbercolumn is enabled
local function numbercolumn_enabled()
	return vim.opt.number:get() or vim.opt.relativenumber:get()
end

-- Condition function to check if foldcolumn is enabled
local function foldcolumn_enabled()
	return vim.opt.foldcolumn:get() ~= "0"
end

-- Helper function to get signs for a specific line
local function get_signs(buf, lnum)
	local signs = {}

	-- Get extmark signs (modern way)
	local extmarks = vim.api.nvim_buf_get_extmarks(
		buf,
		-1,
		{ lnum - 1, 0 },
		{ lnum - 1, -1 },
		{ details = true, type = "sign" }
	)

	for _, extmark in pairs(extmarks) do
		local detail = extmark[4]
		signs[#signs + 1] = {
			name = detail.sign_hl_group or "",
			text = detail.sign_text,
			texthl = detail.sign_hl_group,
			priority = detail.priority,
		}
	end

	-- Sort by priority
	table.sort(signs, function(a, b)
		return (a.priority or 0) < (b.priority or 0)
	end)

	return signs
end

-- Provider function for git signs column
local function git_signcolumn_provider(opts)
	opts = extend_tbl({ escape = false }, opts)
	return function(self)
		local buf = self.bufnr or vim.api.nvim_get_current_buf()
		local signs = get_signs(buf, vim.v.lnum)

		for _, sign in ipairs(signs) do
			if sign.name and sign.name:match("^GitSigns") then
				local text = sign.text or " "
				text = vim.fn.strcharpart(text, 0, 1)
				if #text < 1 then text = " " end
				if sign.texthl then
					return "%#" .. sign.texthl .. "#" .. text .. "%*"
				else
					return text
				end
			end
		end

		return " " -- one space if no git sign
	end
end

-- Provider function for diagnostic signs column
local function diagnostic_signcolumn_provider(opts)
	opts = extend_tbl({ escape = false }, opts)
	return function(self)
		local buf = self.bufnr or vim.api.nvim_get_current_buf()
		local signs = get_signs(buf, vim.v.lnum)

		-- Look for diagnostic signs (highest priority first due to sorting)
		for _, sign in ipairs(signs) do
			if sign.name and (sign.name:match("^DiagnosticSign") or sign.name:match("^Dap")) then
				local text = sign.text or " "
				-- Ensure diagnostic icons have proper width (2 characters)
				if #text == 1 then
					text = text .. " "
				end
				if sign.texthl then
					return "%#" .. sign.texthl .. "#" .. text .. "%*"
				else
					return text
				end
			end
		end

		return "  " -- Two spaces to match diagnostic icon width
	end
end

-- Provider function for the foldcolumn (FFI-based version)
local function foldcolumn_provider(opts)
	opts = extend_tbl({ escape = false }, opts)

	return function(self)
		-- Only show foldcolumn if it's enabled
		if vim.o.foldcolumn == "0" then
			return stylize(" ", opts)
		end

		-- Initialize FFI if not already done
		if not self.ffi then
			self.ffi = require("helpers.fold_ffi")
		end

		-- Get fillchars for fold indicators
		local fillchars = vim.opt.fillchars:get()
		local foldopen = fillchars.foldopen or ""
		local foldclose = fillchars.foldclose or ""
		local foldsep = fillchars.foldsep or " "

		-- Use FFI to get accurate fold information
		local wp = self.ffi.C.find_window_by_handle(0, self.ffi.new("Error"))
		local width = self.ffi.C.compute_foldcolumn(wp, 0)
		local foldinfo = width > 0 and self.ffi.C.fold_info(wp, vim.v.lnum)
			or { start = 0, level = 0, llevel = 0, lines = 0 }

		local str = ""
		if width ~= 0 then
			if foldinfo.level == 0 then
				-- No fold on this line
				str = " "
			else
				local closed = foldinfo.lines > 0
				local first_level = foldinfo.level - width - (closed and 1 or 0) + 1
				if first_level < 1 then
					first_level = 1
				end

				-- For simplicity, just show one character for the fold column
				if vim.v.virtnum ~= 0 then
					str = foldsep
				elseif closed and foldinfo.start == vim.v.lnum then
					-- This is the first line of a closed fold
					str = foldclose
				elseif foldinfo.start == vim.v.lnum and first_level <= foldinfo.llevel then
					-- This is the start of an open fold
					str = foldopen
				else
					-- This is inside a fold but not the start
					str = foldsep
				end
			end
		else
			str = " "
		end

		return stylize(str .. " ", opts)
	end
end

-- Provider function for the numbercolumn (based on heirline-components reference)
local function numbercolumn_provider(opts)
	opts = extend_tbl({ thousands = false, culright = true, escape = false }, opts)
	return function(self)
		local lnum, rnum, virtnum = vim.v.lnum, vim.v.relnum, vim.v.virtnum
		local num, relnum = vim.opt.number:get(), vim.opt.relativenumber:get()

		if not self.bufnr then
			self.bufnr = vim.api.nvim_get_current_buf()
		end

		local str
		if virtnum ~= 0 then
			str = "%="
		elseif not num and not relnum then
			str = "%="
		else
			-- This is the key logic from heirline-components:
			-- If relativenumber is on and we're not on current line (rnum > 0), show relative number
			-- If we're on current line (rnum == 0) and number is on, show absolute line number
			-- Otherwise show absolute line number
			local cur = relnum and (rnum > 0 and rnum or (num and lnum or 0)) or lnum

			if opts.thousands and cur > 999 then
				cur = tostring(cur)
					:reverse()
					:gsub("%d%d%d", "%1" .. opts.thousands)
					:reverse()
					:gsub("^%" .. opts.thousands, "")
			end

			-- Right align the number with minimal space for fold column
			str = "%=" .. cur
		end

		return stylize(str, opts)
	end
end

-- Build the git signcolumn component
local function build_git_signcolumn(opts)
	opts = extend_tbl({
		git_signcolumn = {},
		condition = signcolumn_enabled,
	}, opts)

	return {
		condition = opts.condition,
		provider = git_signcolumn_provider(opts.git_signcolumn),
	}
end

-- Build the diagnostic signcolumn component
local function build_diagnostic_signcolumn(opts)
	opts = extend_tbl({
		diagnostic_signcolumn = {},
		condition = signcolumn_enabled,
	}, opts)

	return {
		condition = opts.condition,
		provider = diagnostic_signcolumn_provider(opts.diagnostic_signcolumn),
	}
end

-- Build the foldcolumn component
local function build_foldcolumn(opts)
	opts = extend_tbl({
		foldcolumn = {},
		condition = foldcolumn_enabled,
	}, opts)

	return {
		condition = opts.condition,
		provider = foldcolumn_provider(opts.foldcolumn),
	}
end

-- Build the numbercolumn component
local function build_numbercolumn(opts)
	opts = extend_tbl({
		numbercolumn = { padding = { right = 1 } },
		condition = numbercolumn_enabled,
	}, opts)

	return {
		condition = opts.condition,
		provider = numbercolumn_provider(opts.numbercolumn),
	}
end

-- Main statuscolumn component
M.statuscolumn = {
	build_diagnostic_signcolumn(),
	build_git_signcolumn(),
	build_numbercolumn(),
	build_foldcolumn(),
}

return M
