-- Basic editor's view
vim.wo.number = true 
vim.wo.relativenumber = true

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Copy & Paste
vim.opt.clipboard = "unnamedplus"

-- Indent
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Editor
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ", 
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸"
}

-- etc
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true

