return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"dockerfile",
					"yaml",
					"python",
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
			})
		end,
	},
}
