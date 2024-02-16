local cmp = prequire "cmp"
if not cmp then
  return
end

local luasnip = prequire "luasnip"
if not luasnip then
  return
end

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local lsp_symbols = require "icons.lspkind"
-- local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup {
  -- disable completion in comments
  enabled = function()
    -- disable completion in comments
    local context = require "cmp.config.context"
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
    end
  end,

  completion = {
    completeopt = "menu,menuone",
  },

  sources = {
    { name = "luasnip", keyword_length = 2 },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "path", keyword_length = 3 },
    { name = "buffer" },
    { name = "nvim_lsp_signature_help", keyword_length = 3 },
  },

  mapping = {

    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    -- ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    -- ["<CR>"] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Insert,
    --   select = true,
    -- },
    -- ["<CR>"] = cmp.mapping {
    --   c = function(default)
    --     if cmp.visible() then
    --       return cmp.confirm { select = false }
    --     end
    --
    --     default()
    --   end,
    -- },
    -- ["<CR>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i", "c" }), -- prevents executing an autocompleted command in cmd mode
    ["<CR>"] = cmp.mapping {
      -- insert mode
      i = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          return cmp.confirm { select = true }
        end

        fallback()
      end,
      -- command mode
      -- if cmp menu is visible and an entry is selected, when Enter is pressed, confirm the selection
      c = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.confirm { select = false }
          return
          -- local CR = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
          -- return vim.api.nvim_feedkeys(CR, "n", true)
        end

        fallback()
      end,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },

  formatting = {
    format = function(entry, item)
      -- item.menu = " " .. item.kind .. " "
      item.kind = lsp_symbols[item.kind] .. "  " .. item.kind .. "  "
      -- item.menu = ({
      --   buffer = "[Buffer]",
      --   nvim_lsp = "[LSP]",
      --   luasnip = "[Snippet]",
      --   path = "[Path]",
      -- })[entry.source.name]

      return item
    end,
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

-- enables autocompletion when entering / or :
cmp.setup.cmdline("/", {
  completion = {
    completeopt = "menu,menuone,noselect", -- don't select first item by default
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  completion = {
    completeopt = "menu,menuone,noselect", -- don't select first item by default
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
