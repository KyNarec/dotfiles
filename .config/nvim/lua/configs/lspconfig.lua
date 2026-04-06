require("nvchad.configs.lspconfig").defaults()

local servers = {
    "html",
    "cssls",
    "bashls",
    "pyright",
    "ruff",
    "clangd",
    "texlab",
    "ltex_plus",
    "lua_ls",
    "jdtls",
    "css-variables-language-server",
    "tinymist",
    "jdtls",
    "kotlin_lsp",
    "qmlls",
    -- "kotlin_language_server",
}

-- Fix for lsp-line.nvim
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local floating = vim.api.nvim_win_get_config(0).relative ~= ""
        vim.diagnostic.config {
            virtual_text = floating,
            virtual_lines = not floating,
        }
    end,
})

vim.diagnostic.config {
    -- virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
}

vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
})

vim.lsp.config("texlab", {
    on_attach = function(client, bufnr) end,
    settings = {
        texlab = {
            diagnostics = {
                ignoredPatterns = {
                    "(badness 10000)",
                },
            },
            experimental = {
                citationCommands = { "cite", "parencite", "footcite", "mcite" },
            },
        },
    },
})

vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false

        vim.keymap.set("n", "<leader>rc", function()
            -- Made with Google Gemini
            -- 1. Save the file first
            vim.cmd "write"

            -- 2. Dynamically get the filename without .c
            local file_no_ext = vim.fn.expand "%:r"
            local file_with_ext = vim.fn.expand "%"

            -- 3. Determine the command
            local cmd
            if vim.fn.filereadable "Makefile" == 1 then
                -- Standard practice: run make, then the binary named after the file
                cmd = string.format("make && ./%s", file_no_ext)
            else
                -- Compiles 'main.c' into 'main' and runs it
                cmd = string.format("gcc %s -o %s -lm && ./%s", file_with_ext, file_no_ext, file_no_ext)
            end

            -- 4. Execute and clean up
            -- Using 'split | term' as requested
            vim.cmd("split | term " .. cmd)

            -- Optional: Auto-scroll to bottom of terminal
            vim.cmd "startinsert"
        end, { buffer = bufnr, desc = "Run C Project/File" })
    end,
})

vim.lsp.config("pyright", {
    filetypes = { "python" },
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = {
        "*.hl",
        "Settings.conf",
        "Keybinds.conf",
        "Monitors.conf",
        "WindowRules.conf",
        "ENVariables.conf",
        "Startup_Apps.conf",
        "WorkspaceRules.conf",
        "LaptopDisplay.conf",
        "UserKeybinds.conf",
        "Laptops.conf",
        "UserSettings.conf",
    },
    callback = function(event)
        vim.lsp.start {
            name = "hyprlang",
            cmd = { "hyprls" },
            root_dir = vim.fn.getcwd(),
        }
    end,
})

vim.lsp.config("css-variables-language-server", {
    filetypes = { "css" },
    cmd = { "css-variables-language-server", "--stdio" },
})

vim.lsp.config("qmlls", {
    cmd = { "qmlls" },
})

vim.lsp.config("svelte", {
    filetypes = { "svelte" },
})

vim.lsp.config("kotlin_lsp", {
    filetypes = { "kotlin", "kt", "kts" },
    -- root_dir = require("lspconfig.util").root_pattern(
    --     "settings.gradle",
    --     "settings.gradle.kts",
    --     "build.gradle",
    --     "build.gradle.kts"
    -- ),
})

vim.lsp.config("cssls", {
    filetypes = { "css" },
    settings = {
        css = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})

vim.lsp.config("ltex_plus", {
    cmd = { "ltex-ls-plus" },
    filetypes = { "bib", "tex" },
    root_markers = { ".git" },
    settings = {
        ltex = {
            -- Set to false to prevent LTeX from creating or reading project-specific .ltex.json files
            diagnostic = {
                fileConfig = {
                    enabled = false,
                },
            },
            language = "de-DE",
            enabled = { "latex", "tex" },
        },
    },
    on_attach = function(client, bufnr)
        require("ltex-utils").on_attach(bufnr)
        vim.keymap.set(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            { desc = "LSP Code Actions", buffer = bufnr }
        )
    end,
})

vim.lsp.config("tinymist", {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
    },
})

-- Uncomment when nvim-java fixes 'require("lspconfig)'
-- https://github.com/nvim-java/nvim-java/issues/427
vim.lsp.config("jdtls", {
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "jr", "lua require('java').runner.built_in.run_app({})", opts)
    end,
    filetypes = { "java" },
    settings = {
        java = {
            project = {
                referencedLibraries = {
                    "libs/*",
                    "+libs/*",
                },
            },
        },
    },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
