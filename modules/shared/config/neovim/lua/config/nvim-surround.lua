local nvim_surround = prequire "nvim-surround"
if not nvim_surround then
  return
end

nvim_surround.setup {
  keymaps = {
    normal = "<leader>sa",
    normal_cur = "<leader>saa", -- surround entire line
    normal_line = false,
    normal_cur_line = false,
    visual = "<leader>s",
    visual_line = "<leader>S",
    delete = "<leader>sd",
    change = "<leader>sr",
  },
  aliases = {
    ["b"] = "]", -- brackets
    ["r"] = ")", -- round
    ["c"] = "}", -- curly
  },
  move_cursor = false,
}
