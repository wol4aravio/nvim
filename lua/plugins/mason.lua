return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- Lua
					"lua_ls",
					"stylua",
					-- Docker
					"docker_language_server",
					"dockerls",
					"docker_compose_language_service",
					-- Files
					"yamlls",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"prettierd",
				},
				run_on_start = true,
				auto_update = false,
			})
		end,
	},
}
