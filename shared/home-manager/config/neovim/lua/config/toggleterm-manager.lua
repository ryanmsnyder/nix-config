local toggleterm_manager = prequire "toggleterm-manager"
if not toggleterm_manager then
  return
end

local actions = toggleterm_manager.actions

toggleterm_manager.setup() 
