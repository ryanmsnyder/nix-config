local fidget = prequire "fidget"
if not fidget then
  return
end

fidget.setup {
  text = {
    spinner = "circle",
    done = require("icons.icons").Check,
  },
}
