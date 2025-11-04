return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
            require("neo-tree").setup({
                close_if_last_window = true,
            })
        end
    }
}
