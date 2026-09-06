return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		enabled = true,

		-- Render в normal mode, обычный Markdown в insert mode.
		render_modes = { "n", "c" },

		-- GitHub / Obsidian-style callouts и прочий стандартный rendering.
		preset = "none",

		heading = {
			enabled = true,
			sign = false,
		},

		code = {
			enabled = true,
			sign = false,
		},

		checkbox = {
			enabled = true,
		},

		quote = {
			enabled = true,
		},

		pipe_table = {
			enabled = true,
		},
	},

	keys = {
		{
			"<leader>mt",
			"<cmd>RenderMarkdown toggle<CR>",
			desc = "Toggle Markdown render",
		},
	},
}