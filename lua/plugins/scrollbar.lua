return {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("scrollbar").setup({
            scrollbar = {
                show = true,
                visibility = "active",
                hide_if_all_visible = true,

                thumb = {
                    text = " ",
                    blend = 30,
                    highlight = "CursorColumn",
                },
            },

            marks = {
                Cursor = {
                    text = "•",
                    highlight = "Normal",
                },
            },

            exclude = {
                buftypes = {
                    terminal = true,
                },
                filetypes = {
                    NvimTree = true,
                    dashboard = true,
                    lazy = true,
                    TelescopePrompt = true,
                    prompt = true,
                },
            },

            providers = {
                cursor = true,
                diagnostic = true,
                gitsigns = false,
                search = false,
                ale = false,
                marks = false,
            },
        })
    end,
}