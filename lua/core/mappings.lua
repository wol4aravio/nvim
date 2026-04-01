-- Global
vim.g.mapleader = " "

-- Insret mode
vim.keymap.set("i", "jj", "<Esc>")

-- Navigation
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "\\", ":split<CR>")

-- Bindings for plugins
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Bufferline
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>bx", "<cmd>BufferLinePickClose<CR>", { desc = "Pick close buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>Bdelete!<CR>", { desc = "Force delete buffer" })
