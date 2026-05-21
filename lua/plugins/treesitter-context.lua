return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		enable = true,

		max_lines = 4,

		mode = "cursor",

		line_numbers = true,

		multiline_threshold = 3,

		separator = "─",

		on_attach = function(bufnr)
			local excluded_filetypes = {
				NvimTree = true,
				dashboard = true,
				lazy = true,
				TelescopePrompt = true,
			}

			return not excluded_filetypes[vim.bo[bufnr].filetype]
		end,
	},
}
