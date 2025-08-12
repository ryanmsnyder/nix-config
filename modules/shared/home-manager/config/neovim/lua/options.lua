-- shortcuts
local g = vim.g -- global variables
local opt = vim.opt -- editor options

local icons = require("icons.icons")

-- set leader key to Space
g.mapleader = " "

-- set system clipboard as default
opt.clipboard = "unnamedplus"

-- enable current line highlighting
opt.cursorline = true

-- set maximum amount of completion items to 10
opt.pumheight = 10

-- complete even if there's only one item; do not autoselect item
opt.completeopt = "menu,menuone,noselect"

-- make splits open to down and right
opt.splitbelow = true
opt.splitright = true

-- number stuff
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

opt.guicursor = {
	"n-v-c-sm:block", -- normal, visual, command: block
	"i-ci-ve:ver25", -- insert, command-insert, visual-excl: vertical bar
	"r-cr-o:hor20", -- replace modes: horizontal bar
	"t:block", -- terminal: block (no blink)
	"a:blinkon0", -- disable blinking everywhere
}

-- tab stuff
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.shiftwidth = 2

-- disable intro
opt.shortmess:append("sI")

-- enable terminal colors
opt.termguicolors = true

-- don't show mode since mode is displayed in lualine
opt.showmode = false

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- preserve undo history for a file across editing sessions
opt.undofile = true

-- recommended by auto-session plugin
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- disable shada
-- opt.shadafile = "NONE"

-- disable swap
-- g.noswapfile = true
-- g.nobackup = true

g.copy_cut = true -- copy cut text ( x key ), visual and normal mode
g.copy_del = true -- copy deleted text ( dd key ), visual and normal mode
g.insert_nav = true -- navigation in insertmode

opt.hidden = true
opt.ignorecase = true
opt.smartcase = true

opt.mouse = "a"
opt.shiftwidth = 2
opt.smartindent = true
opt.timeoutlen = 400
opt.ruler = false
opt.updatetime = 250

-- keep column to the left of line numbers visible to prevent screen movement when
-- diagnostic signs appear in the column
-- opt.signcolumn = "yes"

-- make status line global (span the entire bottom)
opt.laststatus = 3

-- blankline support
-- opt.list = true
-- opt.listchars:append { space = "⋅" }

-- disable built-in plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

g.do_filetype_lua = 1

-- -- override filetype
-- vim.filetype.add {
--   -- extension = {
--   --     foo = "fooscript",
--   -- },
--   filename = {
--     ["Podfile"] = "ruby",
--   },
--   pattern = {
--     [".*git/config"] = "gitconfig",
--     [".*env.*"] = "sh",
--   },
-- }

-- set diagnostic floating window to round border
-- Consolidated diagnostic configuration
vim.diagnostic.config({
	-- Float window styling
	float = { border = "rounded" },

	-- Explicitly enable underlines (default: true)
	underline = true,

	-- Configure signs for diagnostics
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.INFO] = icons.Info,
			[vim.diagnostic.severity.HINT] = icons.Hint,
		},
	},

	-- Optional: Configure virtual text
	virtual_text = {
		spacing = 2,
		prefix = "●",
	},
})

opt.fillchars = {
	-- vert = "▏", -- fixes vertical window split between neo-tree and buffer
	-- vert = "▕", -- fixes vertical window split between neo-tree and buffer
	-- horiz = "▁", -- fixes horizontal window split between trouble and buffer
	-- horiz = "━",
	-- horizup = "┻",
	-- horizup = "▁",
	-- horizdown = "┳",
	-- vert = "┃",
	-- vertleft = "┫",
	-- vertright = "┣",
	-- vertright = "▏",
	-- verthoriz = "╋",

	eob = " ",
	fold = " ",
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	diff = "/",
}

-- refresh buffer when file changes on disk
opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- signcolumn configuration
vim.opt.signcolumn = "yes:1"

-- basic fold settings for FFI-based folding
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
