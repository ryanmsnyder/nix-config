local toggleterm = prequire "toggleterm"
if not toggleterm then
  return
end

toggleterm.setup {
  size = function(term)
    if term.direction == "horizontal" then
      -- if less than 40 lines, make terminal half of window, else a third of the window
      local lines = vim.o.lines
      if lines < 40 then
        return lines * 0.5
      else
        return lines * 0.3
      end
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  ignore_filetypes = { "neo-tree" },
  shade_filetypes = {},
  shade_terminals = false,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = false,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
}

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<C-x>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
local Terminal = require("toggleterm.terminal").Terminal

-- vim.keymap.set(
--   "t",
--   "<C-x>",
--   vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
--   { desc = "Escape terminal mode" }
-- )

-- t = {
--     ["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
--   },

-- local lazygit = Terminal:new { cmd = "lazygit", hidden = true }
--
-- function _LAZYGIT_TOGGLE()
--   lazygit:toggle()
-- end
--
-- local node = Terminal:new { cmd = "node", hidden = true }
--
-- function _NODE_TOGGLE()
--   node:toggle()
-- end
--
-- local ncdu = Terminal:new { cmd = "ncdu", hidden = true }
--
-- function _NCDU_TOGGLE()
--   ncdu:toggle()
-- end
--
-- local htop = Terminal:new { cmd = "htop", hidden = true }
--
-- function _HTOP_TOGGLE()
--   htop:toggle()
-- end
--
-- local python = Terminal:new { cmd = "python", hidden = true }
--
-- function _PYTHON_TOGGLE()
--   python:toggle()
-- end
