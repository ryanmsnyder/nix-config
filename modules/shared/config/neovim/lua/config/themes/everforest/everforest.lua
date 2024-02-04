local M = {}
M.before = function(background, flavor)
  local everforest = prequire "everforest"

  if not everforest then
    return
  end
  vim.o.background = background
  everforest.setup { background = flavor }
end

return M
