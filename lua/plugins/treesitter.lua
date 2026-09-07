return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup({})

            treesitter.install({
                "lua",
                "dockerfile",
                "yaml",
                "python",

                -- Нужны render-markdown.nvim
                "markdown",
                "markdown_inline",
            })

            -- В новой версии nvim-treesitter highlighting
            -- включается через native Neovim API.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}