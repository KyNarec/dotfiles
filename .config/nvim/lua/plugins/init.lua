return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "nvim-neotest/nvim-nio",
    },

    -- {
    --     "rcasia/neotest-java",
    --     ft = "java",
    --     dependencies = {
    --         "mfussenegger/nvim-jdtls",
    --         "mfussenegger/nvim-dap", -- for the debugger
    --         "rcarriga/nvim-dap-ui", -- recommended
    --         "theHamsta/nvim-dap-virtual-text", -- recommended
    --     },
    -- },
    -- {
    --     "nvim-neotest/neotest",
    --     dependencies = {
    --         "nvim-neotest/nvim-nio",
    --         "nvim-lua/plenary.nvim",
    --         "antoinemadec/FixCursorHold.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("neotest").setup {
    --             adapters = {
    --                 require "neotest-java" {
    --                     junit_jar = nil, -- default: stdpath("data") .. /nvim/neotest-java/junit-platform-console-standalone-[version].jar
    --                     incremental_build = true,
    --                 },
    --             },
    --         }
    --     end,
    -- },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            -- NOTE: Neotest-java is a dependency of nvim-java, so we check for it here.
            local java_adapter = require "neotest-java"
            require("neotest").setup {
                adapters = {
                    java_adapter, -- Rely on nvim-java's test setup
                },
            }
        end,
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
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"
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
        end,
    },

    {
        "mfussenegger/nvim-dap",
        config = function(_, opts)
            -- require("configs.utils").load_mappings "dap"
        end,
    },
    --
    -- {
    --   "mfussenegger/nvim-dap-python",
    --   ft = "python",
    --   dependencies = {
    --     "mfussenegger/nvim-dap",
    --     "rcarriga/nvim-dap-ui",
    --     "nvim-neotest/nvim-nio",
    --   },
    --   config = function(_, opts)
    --     local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
    --     require("dap-python").setup(path)
    --     require("core.utils").load_mappings("dap_python")
    --   end,
    -- },

    {
        "nvimtools/none-ls.nvim",
        ft = { "python" },
        opts = function()
            return require "custom.configs.null-ls"
        end,
    },

    --- RUST

    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false,
        ft = { "rust" }, -- Load only for Rust files
    },
    {
        "rust-lang/rust.vim",
        lazy = false,
        filetypes = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        "saecki/crates.nvim",
        ft = { "toml" },
        config = function(_, opts)
            local crates = require "crates"
            crates.setup(opts)
            require("cmp").setup.buffer {
                sources = { { name = "crates" } },
            }
            crates.show()
            -- require("core.utils").load_mappings "crates"
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = false,
        config = function(_, opts)
            require("nvim-dap-virtual-text").setup()
        end,
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
                "svelte",
                "css",
            },
        },
    },

    -- LaTeX support
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_quickfix_ignore_filters = "Underfull \\hbox"
            vim.g.vimtex_quickfix_mode = 1
            vim.g.vimtex_compiler_latexmk = {
                aux_dir = ".texfiles/",
                -- out_dir = ".texfiles/",
            }
        end,
    },

    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        lazy = false,
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("lsp_lines").setup()
        end,
    },

    -- to fully build this plugin, go into any markdown file and do: :call mkdp#util#install()
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
            vim.g.mkdp_browser = "brave"
        end,
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
    },

    {
        "jhofscheier/ltex-utils.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim", -- Used for selecting code actions
        },
        enabled = { "latex", "tex", "bib", "markdown" },
        config = function()
            require("ltex-utils").setup {
                -- Optional: Configure where dictionaries are saved, etc.
                -- Defaults are usually fine.
                path = ".ltex/",
            }
        end,
    },
}
