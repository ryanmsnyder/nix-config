local neotree = prequire("neo-tree")
if not neotree then
	return
end

neotree.setup({
	close_if_last_window = true,
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function()
				-- This effectively hides the cursor
				vim.api.nvim_set_hl(0, "HIDDEN", { blend = 100, nocombine = true })
				vim.o.guicursor = "a:HIDDEN"
			end,
		},
		{
			event = "neo_tree_popup_buffer_enter",
			handler = function()
				vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
			end,
		},
		{
			event = "neo_tree_buffer_leave",
			handler = function()
				vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
			end,
		},
		{
			event = "neo_tree_popup_input_ready",
			---@param args { bufnr: integer, winid: integer }
			handler = function(args)
				vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
				-- vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
			end,
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
				".DS_Store",
			},
		},

		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_current",
	},
	default_component_configs = {
		indent = {
			padding = 1,
			with_markers = false,
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
		},
		git_status = {
			symbols = {
				staged = "󰱒",
			},
		},
	},
	window = {
		position = "left",
		width = 30,
	},
	-- components ={
	--           name = function(config, node, state)
	--             local result = fc.name(config, node, state)
	--             if node:get_depth() == 1 and node.type ~= "message" then
	--               result.text = vim.fn.fnamemodify(node.path, ":t")
	--             end
	--             return result
	--           end,
	--         },
})
