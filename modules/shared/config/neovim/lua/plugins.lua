return {
  {
    "ryanmsnyder/gruvbox-flat.nvim",
    priority = 1000,
    lazy = false,
    enabled = true,
    -- config = function()
    --   require "config.themes.gruvbox-flat.gruvbox-flat"
    -- end,
  },

  {
    "ryanmsnyder/catppuccin.nvim",
    name = "catppuccin",
    config = function()
      require "config.themes.catppuccin.catppuccin"
    end,
    lazy = false,
    priority = 1000,
  },

  {
    "ryanmsnyder/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
  },

  {
    "zaldih/themery.nvim",
    keys = {
      { "<leader>ht", "<cmd>Themery<cr>", desc = "Open Theme Switcher" },
    },
    config = function()
      require "config.themery"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  {
    "rebelot/heirline.nvim",
    event = "UiEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require "config.heirline.heirline"
    end,
  },

  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "config.lsp_progress"
    end,
  },

  -- {
  --   "j-hui/fidget.nvim",
  --   tag = "legacy",
  --   event = "LspAttach",
  --   config = function()
  --     require "config.fidget"
  --   end,
  --   opts = {
  --     -- options
  --   },
  -- },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main = "ibl",
    config = function()
      require "config.blankline"
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      require "config.smart-splits"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    cmd = {
      "TSUpdate",
      "TSInstallInfo",
      "TSEnable",
      "TSDisable",
      "TSModuleInfo",
      "TSUninstall",
    },
    config = function()
      require "config.treesitter"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "molecule-man/telescope-menufacture" },
    },
    cmd = "Telescope",
    opts = {
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
    },
    config = function()
      require "config.telescope"
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    branch = "v3.x",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require "config.neo-tree"
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufEnter",
    config = function()
      require "config.trouble"
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependncies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require "config.luasnip"
    end,
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     { "hrsh7th/cmp-buffer" },
  --     { "hrsh7th/cmp-cmdline" },
  --     { "hrsh7th/cmp-nvim-lsp" },
  --     { "hrsh7th/cmp-path" },
  --     { "hrsh7th/cmp-nvim-lsp-signature-help" },
  --     { "saadparwaiz1/cmp_luasnip" },
  --   },
  --   config = function()
  --     require "config.cmp"
  --   end,
  -- },

  -- {
  --   "williamboman/mason.nvim",
  --   build = ":MasonUpdate",
  --   cmd = {
  --     "Mason",
  --     "MasonInstall",
  --     "MasonUninstall",
  --     "MasonUninstallAll",
  --     "MasonLog",
  --   },
  --   config = function()
  --     require("mason").setup()
  --   end,
  -- },

  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  -- },

  {
    'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
    lazy = false, -- change this 
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip'
    },
    config = function()
      require "config.lsp.lsp"
    end,
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   event = "BufReadPost",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     -- "williamboman/mason-lspconfig.nvim",
  --   },
  --   config = function()
  --     require "config.lsp.lsp"
  --   end,
  -- },

  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  -- },

  -- {
  --   -- allows for automatically installing formatters like stylua, prettier, and black
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     {
  --       "jose-elias-alvarez/null-ls.nvim",
  --       event = "BufReadPost",
  --       dependencies = { "lukas-reineke/lsp-format.nvim", "nvim-lua/plenary.nvim" },
  --       config = function()
  --         require "config.lsp.null-ls"
  --       end,
  --     },
  --   },
  --   config = function()
  --     require "config.lsp.mason-null-ls"
  --   end,
  -- },

  -- {
  --   "jay-babu/mason-nvim-dap.nvim", -- automatically installs debug adapters
  --   ft = { "python", "javascript", "typescript" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "mfussenegger/nvim-dap",
  --     "rcarriga/nvim-dap-ui",
  --   },
  --   config = function()
  --     require "config.dap.mason-nvim-dap"
  --   end,
  -- },

  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = { "mfussenegger/nvim-dap", "jay-babu/mason-nvim-dap.nvim" },
  --   config = function()
  --     require "config.dap.nvim-dap-ui"
  --   end,
  -- },

  -- {
  --   "Weissle/persistent-breakpoints.nvim",
  --   event = "BufReadPost",
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   config = function()
  --     require "config.dap.persistent-breakpoints"
  --   end,
  -- },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "mattn/emmet-vim",
    event = "BufReadPost",
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
      "html",
      "css",
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  {

    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump {
            search = {
              mode = function(str)
                return "\\<" .. str
              end,
            },
          }
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require "config.nvim-surround"
    end,
  },

  {
    "ryanmsnyder/toggleterm.nvim",
    -- dir = "/Users/ryansnyder/code/neovim-plugins/toggleterm.nvim",
    -- "akinsho/toggleterm.nvim",
    branch = "prod",
    keys = {
      {
        "<C-\\>",
      },
    },
    config = function()
      require "config.toggleterm"
    end,
  },

  {
    "ryanmsnyder/toggleterm-manager.nvim",
    config = function()
      require "config.toggleterm-manager"
    end,
  },

}
