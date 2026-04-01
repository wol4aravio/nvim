return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"wsdjeg/bufdel.nvim",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				separator_style = "slant",

				close_command = function(bufnr)
					require("bufdel").delete(bufnr, { switch = "lastused" })
				end,
				right_mouse_command = function(bufnr)
					require("bufdel").delete(bufnr, { switch = "lastused" })
				end,
				middle_mouse_command = function(bufnr)
					require("bufdel").delete(bufnr, { switch = "lastused" })
				end,

				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
						separator = true,
					},
				},

				show_close_icon = false,
				show_buffer_close_icons = false,
				always_show_bufferline = true,
			},
		})
	end,
}
