local cmp = require "cmp"

local plugins = {

  {
    "nvim-neotest/nvim-nio",
  },

    --- JAVA
  {
    "nvim-java/nvim-java",
    config = false,
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
          servers = {
            jdtls = {
          },
          setup = {
            jdtls = function ()
              require("java").setup({
                java_home = "/usr/lib64/jvm/java-22-openjdk/bin/java",
                java_test = {
                enable = true,
                },
                java_debug_adapter = {
                enable = true,
                },
                spring_boot_tools = {
                enable = true,
                },
              })
            end,
          },
        },
      },
    },
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
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  --- RUST

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
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
    ft = {"toml"},
    config = function(_, opts)
      local crates  = require('crates')
      crates.setup(opts)
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
      crates.show()
      require("core.utils").load_mappings("crates")
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
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
      table.insert(M.sources, {name = "crates"})
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
        "ruff-lsp",

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
    require('lspconfig').jdtls.setup({})
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
      },
    },
	},
}
return plugins
