local toggleterm_manager = prequire "toggleterm-manager"
if not toggleterm_manager then
  return
end

local actions = toggleterm_manager.actions

toggleterm_manager.setup {
  mappings = { -- key mappings bound inside the telescope window
    i = {
      ["<CR>"] = { action = actions.toggle_term, exit_on_action = false }, -- toggles terminal open/closed
      ["<C-i>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
      ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
      ["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
    },
    n = {
      ["<CR>"] = { action = actions.toggle_term, exit_on_action = false }, -- toggles terminal open/closed
      ["<C-i>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
      ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
      ["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
    },
},
} 
