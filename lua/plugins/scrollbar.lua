return {
	"petertriho/nvim-scrollbar",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("scrollbar").setup({
			show = true,
			show_in_active_only = true,
			hide_if_all_visible = true,

			handle = {
				text = " ",
				blend = 30,
				highlight = "CursorColumn",
			},

			marks = {
				Cursor = {
					text = "•",
					highlight = "Normal",
				},
			},

			excluded_buftypes = {
				"terminal",
			},

			excluded_filetypes = {
				"NvimTree",
				"dashboard",
				"lazy",
				"TelescopePrompt",
				"prompt",
			},

			handlers = {
				cursor = true,
				diagnostic = true,
				gitsigns = false,
				handle = true,
				search = false,
				ale = false,
			},
		})
	end,
}

