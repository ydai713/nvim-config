return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("configs.conform")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = { enable = true },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Git client: Lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },

  -- LSP dependencies management
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- python lsp and linter
        "pyright",
        "black",

        -- terraform
        "terraform-ls",
        "tflint",

        -- Javascript / typescript
        "typescript-language-server",

        -- markdown
        "marksman",
      },
    },
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },

  -- Copliot: AI powered code completion
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = require("configs.copilot"),
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = {
      sources = {
        { name = "path", group_index = 1 },
        { name = "luasnip", group_index = 1 },
        { name = "copilot", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
      },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
}
