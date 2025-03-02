local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"},
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    },

    ["<leader>cc"] = {":VimtexCompile <CR>"},
    ["<leader>cv"] = {":VimtexView<CR>"},
    ["<leader>cq"] = {":VimtexStop<CR>"},
    ["<leader>cd"] = {':lua vim.diagnostic.open_float(0, {scope="line"})<CR>'},
    ["<leader>rr"] = {':RustRun<CR>'},
  }
}

M.lspconfig = {
  plugin = true,
  n = {
    ["<leader>jr"] = {
      function ()
        require('java').runner.built_in.run_app({})
      end
    },
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

M.crates = {
  plugin = true,
  n = {
    ["<leader>rcu"] = {
      function ()
        require('crates').upgrade_all_crates()
      end,
      "update crates"
    }
  }
}

return M
