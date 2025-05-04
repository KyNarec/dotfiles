local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local util = require "lspconfig/util"

local servers = {
  "pyright",
  "ruff",
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})

lspconfig.texlab.setup {
  settings = {
    texlab = {
      diagnostics = {
        ignoredPatterns = {
          "(badness 10000)",
        }
      },
    },
  },
}
-- lspconfig.jdtls.setup({})

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
  })
end

-- Hyprlang LSP
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
		pattern = {"*.hl", "Settings.conf", "Keybinds.conf", "Monitors.conf", "WindowRules.conf", "ENVariables.conf", "Startup_Apps.conf", "WorkspaceRules.conf", "LaptopDisplay.conf", "UserKeybinds.conf", "Laptops.conf", "UserSettings.conf"},
		callback = function(event)
				-- print(string.format("starting hyprls for %s", vim.inspect(event)))
				vim.lsp.start {
						name = "hyprlang",
						cmd = {"hyprls"},
						root_dir = vim.fn.getcwd(),
				}
		end
})
