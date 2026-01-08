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
-- map("n", "<leader>tpm", "<Cmd>lua tinymist.pinMainToCurrent <CR>")
vim.keymap.set("n", "<leader>tpm", function()
    vim.lsp.buf.execute_command {
        command = "tinymist.pinMain",
        arguments = { vim.api.nvim_buf_get_name(0) },
    }
    print("Typst: Pinned " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"))
end, { desc = "Typst: Pin Main File" })
-- local nomap = vim.keymap.del
-- nomap("n", "<C-n>")
-- nomap("n", "<leader>e")
-- map("n", "<C-n>", function()
--     Snacks.explorer.open()
-- end)
-- map("n", "<leader>e", function()
--     Snacks.explorer.open()
-- end)
