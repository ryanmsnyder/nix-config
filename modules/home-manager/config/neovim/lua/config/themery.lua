local themery = prequire("themery")
if not themery then
	return
end

themery.setup({
	themes = {
		{
			name = "Everforest dark hard",
			colorscheme = "everforest",
			before = [[
        require "config.themes.everforest".before("dark", "hard")
            ]],
		},
		{
			name = "Everforest dark medium",
			colorscheme = "everforest",
			before = [[
        require "config.themes.everforest".before("dark", "medium")
            ]],
		},
		{
			name = "Everforest dark soft",
			colorscheme = "everforest",
			before = [[
        require "config.themes.everforest".before("dark", "soft")
            ]],
		},
		{
			name = "Everforest light soft",
			colorscheme = "everforest",
			before = [[
        require "config.themes.everforest".before("light", "soft")
            ]],
		},
		{
			name = "Gruvbox dark hard",
			colorscheme = "gruvbox-flat",
			before = [[
        require "config.themes.gruvbox-flat".before("dark")
            ]],
			after = [[
        require "config.themes.gruvbox-flat".after()
      ]],
		},
		{
			name = "Gruvbox dark soft",
			colorscheme = "gruvbox-flat",
			before = [[
        require "config.themes.gruvbox-flat".before("light")
              ]],
			after = [[
        require "config.themes.gruvbox-flat".after()
      ]],
		},
		{
			name = "Catppuccin mocha",
			colorscheme = "catppuccin",
			before = [[
        require "config.themes.catppuccin".before("mocha")
      ]],
		},
		{
			name = "Catppuccin macchiato",
			colorscheme = "catppuccin",
			before = [[
        require "config.themes.catppuccin".before("macchiato")
            ]],
		},
		{
			name = "Catppuccin frappe",
			colorscheme = "catppuccin",
			before = [[
        require "config.themes.catppuccin".before("frappe")
            ]],
		},
		{
			name = "Catppuccin latte",
			colorscheme = "catppuccin",
			before = [[
        require "config.themes.catppuccin".before("latte")
            ]],
		},
	},
	-- themeConfigFile = "~/.config/nvim/lua/theme.lua", -- for persistence
	livePreview = true, -- apply theme while browsing
})
