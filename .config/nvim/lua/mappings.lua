require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>cc", ":VimtexCompile <CR>", { desc = "Compile LaTeX file" })
map("n", "<leader>cv", ":VimtexView <CR>", { desc = "View compiled LaTeX file" })
map("n", "<leader>cq", ":VimtexStop <CR>", { desc = "Stop compiling LaTeX file" })

map("n", "<leader>rr", ":Cargo run <CR>", { desc = "Run current rust file with cargo" })
map(
    "n",
    "<leader>cd",
    ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
    { desc = "Show diagnostics in current line" }
)

-- map("n", "<leader>tc", "<Cmd>lua tinymist.exportPdf()<CR>", { desc = "Typst Compile" })

-- local nomap = vim.keymap.del
-- nomap("n", "<C-n>")
-- nomap("n", "<leader>e")
-- map("n", "<C-n>", function()
--     Snacks.explorer.open()
-- end)
-- map("n", "<leader>e", function()
--     Snacks.explorer.open()
-- end)
