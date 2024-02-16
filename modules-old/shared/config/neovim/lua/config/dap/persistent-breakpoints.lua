local persistent_breakpoints = prequire "persistent-breakpoints"

if not persistent_breakpoints then
  return
end

persistent_breakpoints.setup {
  load_breakpoints_event = { "BufReadPost" },
}
