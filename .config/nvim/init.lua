require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- autosave
--vim.cmd([[autocmd TextChanged,TextChangedI * silent! write]])-- Lua

-- following code is used to make nvim use the correct runtime path so that spell checking works
local data_path = vim.fn.stdpath("data")

-- Prepend the Neovim data path to the runtimepath.
-- This ensures Neovim looks for spell/ and other core files in the right spot.
vim.o.runtimepath = data_path .. "," .. vim.o.runtimepath
