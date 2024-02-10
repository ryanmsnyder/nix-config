local lsp_progress = prequire "lsp-progress"
if not lsp_progress then
  return
end

lsp_progress.setup {
  -- how long messaged is displayed on statusline
  decay = 3000,

  -- gets passed into client_format (below) as series_messages
  series_format = function(title, message, percentage, done)
    local builder = {}
    local test = {}
    local has_title = false
    local has_message = false
    if title and title ~= "" then
      table.insert(builder, title)
      test["title"] = title
      has_title = true
    end
    if message and message ~= "" then
      table.insert(builder, message)
      test["message"] = message
      has_message = true
    end
    if percentage and (has_title or has_message) then
      table.insert(builder, string.format("(%.0f%%%%)", percentage))
      test["percentage"] = percentage
    end
    if done and (has_title or has_message) then
      test["done"] = done
      -- table.insert(builder, require("icons").Check)
    end

    -- local file = io.open("/Users/ryan.snyder/Desktop/output.txt", "a")
    -- local myString = table.concat(builder, " ")

    -- if file then
    --   file:write(vim.inspect(test))
    --   file:close()
    -- else
    --   print "Could not open file for writing"
    -- end

    return { msg = table.concat(builder, " "), done = done }
    -- return table.concat(builder, " ")
    -- return builder
  end,

  client_format = function(client_name, spinner, series_messages)
    if #series_messages == 0 then
      return nil
    end
    local builder = {}
    for _, series in ipairs(series_messages) do
      if series.done then
        spinner = require("icons.icons").Check -- replace your check mark
      end
      table.insert(builder, series.msg)
    end
    return "[" .. client_name .. "] " .. spinner .. " " .. table.concat(builder, ", ")
  end,

  format = function(client_messages)
    -- local sign = " LSP" -- nf-fa-gear \uf013
    return #client_messages > 0 and (table.concat(client_messages, " "))
  end,
}
