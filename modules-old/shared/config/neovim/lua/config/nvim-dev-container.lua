local dev_container = prequire "devcontainer"
if not dev_container then
  return
end

dev_container.setup {
  attach_mounts = {
    neovim_config = {
      enabled = true,
      options = { "readonly" },
    },
    neovim_data = {
      enabled = false,
      options = {},
    },
    -- Only useful if using neovim 0.8.0+
    neovim_state = {
      enabled = false,
      options = {},
    },
  },
  container_runtime = "docker",
}
