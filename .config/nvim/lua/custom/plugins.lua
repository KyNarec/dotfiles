local cmp = require "cmp"

local plugins = {

  {
    "nvim-neotest/nvim-nio",
  },

  {
    "nvim-java/nvim-java",
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
                "libs/flatlaf-3.5.1.jar",
                "libs/Engine.Alpha.jar",
                "libs/jl1.0.1.jar",
                "libs/Liste.jar"
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
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require "custom.configs.rustaceanvim"
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
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
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
      },
    },
  },

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
      },
    },
  },

  -- LaTeX support
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- vim.g.tex_flavor = "latex"
      -- vim.g.vimtex_quickfix_mode = 0
      -- vim.g.vimtex_mappings_enabled = 0
      -- vim.g.vimtex_indent_enabled = 0

      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_context_pdf_viewer = "zathura"
    end,
  },

  {
    'maan2003/lsp_lines.nvim',
    url = "git@github.com:maan2003/lsp_lines.nvim.git",
    lazy = false,
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },
}
return plugins
