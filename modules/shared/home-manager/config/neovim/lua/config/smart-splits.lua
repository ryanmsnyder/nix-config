local smartsplits = prequire("smart-splits")
if not smartsplits then
	return
end

smartsplits.setup({
	-- Ignored filetypes (only while resizing)
	ignored_filetypes = {
		"nofile",
		"quickfix",
		"prompt",
	},
	-- Ignored buffer types (only while resizing)
	ignored_buftypes = { "neo-tree" },
	-- the default number of lines/columns to resize by at a time
	default_amount = 3,
	at_edge = "stop",
	-- when moving cursor between splits left or right,
	-- place the cursor on the same row of the *screen*
	-- regardless of line numbers. False by default.
	-- Can be overridden via function parameter, see Usage.
	move_cursor_same_row = false,
	-- whether the cursor should follow the buffer when swapping
	-- buffers by default; it can also be controlled by passing
	-- `{ move_cursor = true }` or `{ move_cursor = false }`
	-- when calling the Lua function.
	cursor_follows_swapped_bufs = true,

	-- ignore these autocmd events (via :h eventignore) while processing
	-- smart-splits.nvim computations, which involve visiting different
	-- buffers and windows. These events will be ignored during processing,
	-- and un-ignored on completed. This only applies to resize events,
	-- not cursor movement events.
	ignored_events = {
		"BufEnter",
		"WinEnter",
	},
	-- enable or disable a multiplexer integration;
	-- automatically determined, unless explicitly disabled or set,
	-- by checking the $TERM_PROGRAM environment variable,
	-- and the $KITTY_LISTEN_ON environment variable for Kitty
	multiplexer_integration = nil,
	-- disable multiplexer navigation if current multiplexer pane is zoomed
	-- this functionality is only supported on tmux and Wezterm due to kitty
	-- not having a way to check if a pane is zoomed
	disable_multiplexer_nav_when_zoomed = true,
	-- default logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
	log_level = "info",
})
