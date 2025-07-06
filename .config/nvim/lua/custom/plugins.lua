local cmp = require "cmp"

local plugins = {

  {
    "nvim-neotest/nvim-nio",
  },

  {
    "nvim-java/nvim-java",
    ft = { "java" },
    lazy = false,
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    config = function()
      require("java").setup {}
      require("lspconfig").jdtls.setup {
        on_attach = require("plugins.configs.lspconfig").on_attach,
        capabilities = require("plugins.configs.lspconfig").capabilities,
        filetypes = { "java" },
        settings = {
          java = {
            project = {
              referencedLibraries = {
                "libs/*",
                -- "+libs/binbaum_ohne.jar",
                -- "+libs/binbaum_mit.jar",
                -- "+libs/flatlaf-3.5.1.jar",
                "+libs/*"
              }
            }
          }
        }
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },

  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("core.utils").load_mappings("dap")
    end
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    ft = { "python" },
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  --- RUST

  {
    'mrcjkb/rustaceanvim',
    version = '^5',  -- Recommended
    lazy = false,
    ft = { 'rust' }, -- Load only for Rust files
  },
  {
    "rust-lang/rust.vim",
    lazy = false,
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    'saecki/crates.nvim',
    ft = { "toml" },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      require('cmp').setup.buffer({
        sources = { { name = "crates" } }
      })
      crates.show()
      require("core.utils").load_mappings("crates")
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      table.insert(M.sources, { name = "crates" })
      return M
    end
  },


  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        --- java
        "jdtls",
        "java-test",
        "java-debug-adapter",
        "openjdk-23",

        --- bash
        "bash-language-server",

        --- python
        "black",
        "debugpy",
        "pyright",
        "mypy",
        "ruff",

        --- c & c++
        "clangd",
        "clang-format",
        "codelldb",

        --- rust
        "rust-analyzer",

        --- LaTex
        "texlab",
        "latexindent",

        -- Hyprland
        "hyprls",

        -- Kotlin
        "kotlin-language-server",
        
        -- Lua
        "lua-language-server"
      },
    },
    version = "1.9.0",
  },

  { "mason-org/mason-lspconfig.nvim", version = "1.9.0" },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
    -- require('lspconfig').jdtls.setup({})
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "c",
        "cpp",
        "lua",
        "rust",
        "java",
        "kotlin",
        "bash",
        "csv",
        "json",
        "hyprlang",
        "markdown",
        "xml",
        "yaml",
        "qmljs",
      },
    },
  },

  -- LaTeX support
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_quickfix_ignore_filters = 'Underfull \\hbox'
      vim.g.vimtex_quickfix_mode = 1
    end,
  },
  -- Useless rn
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    lazy = false,
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      -- Safely require the plugin
      local ok, lsp_lines = pcall(require, "lsp_lines")
      if not ok then return end

      -- Initialize lsp_lines
      -- vim.diagnostic.config({ virtual_text = false }) -- commented out, because it brakes the plugin

      lsp_lines.setup()
    end,

  },

  -- to fully build this plugin, go into any markdown file and do: :call mkdp#util#install()
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }

}
return plugins
