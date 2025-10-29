return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					-- "lua",
					-- "dockerfile",
					-- "helm",
					-- "javascript",
					-- "typescript",
					-- "python",
                    -- "go",
                    -- "rust",
                    -- "json",
                    -- "yaml",
                    -- "kotlin",
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
			})
		end,
	},
}
