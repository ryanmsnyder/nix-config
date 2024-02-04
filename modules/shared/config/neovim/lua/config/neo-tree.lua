local neotree = prequire "neo-tree"
if not neotree then
  return
end

neotree.setup {
  close_if_last_window = true,
  enable_normal_mode_for_inputs = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
      },
    },

    follow_current_file = { enabled = false },
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
}
