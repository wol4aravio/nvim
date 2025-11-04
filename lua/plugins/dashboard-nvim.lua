return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
        require('dashboard').setup({
            theme = "hyper",
            config = {
                week_header = { enable = true }, -- show day name
                project = { enable = true, limit = 3, action = 'Telescope find_files cwd=' }, -- show projects block
                mru = { enable = false }, -- hide recently opened files
                shortcut = {
                    { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
                    { desc = "󰩈 Quit", group = "@property", action = "q", key = "q" },
                },
            },
        })
    end,
    dependencies = {{ "nvim-tree/nvim-web-devicons" }},
}
