return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			-- =====================
			-- Supported languages
			-- =====================

			-- Lua
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- Docker
			vim.lsp.enable("docker_language_server")
			vim.lsp.enable("dockerls")
			vim.lsp.enable("docker_compose_language_service")

			-- Text files
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						validate = true,
						hover = true,
						completion = true,
						schemas = {
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
								"docker-compose.yml",
								"docker-compose.yaml",
								"compose.yml",
								"compose.yaml",
							},
						},
					},
				},
			})
			vim.lsp.enable("yamlls")

			-- Python (Pyright + Ruff)
			local python = require("core.python")

			local python_root_markers = {
				".venv",
				"venv",
				".env",
				"env",

				"pyproject.toml",
				"poetry.lock",
				"uv.lock",
				"Pipfile",
				"requirements.txt",
				"setup.py",
				"setup.cfg",
				"pyrightconfig.json",
				".git",
			}

			-- root_dir for env manager (uv/poetry/venv) & standalone files
			local function python_root_dir(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				if fname == "" then
					return on_dir(nil)
				end
				local root = vim.fs.root(fname, python_root_markers)
				on_dir(root or vim.fs.dirname(fname))
			end

			-- Pyright: аutocomplete + hover/docs + type checking
			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				root_dir = python_root_dir,
				before_init = function(_, config)
					local root_dir = config.root_dir or vim.fn.getcwd()
					local python_path = python.get_python_path(root_dir)

					config.settings = config.settings or {}
					config.settings.python = config.settings.python or {}
					config.settings.python.pythonPath = python_path
				end,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			})
			vim.lsp.enable("pyright")

			-- Ruff: lint + quickfix/code actions
			vim.lsp.config("ruff", {
				cmd = { "ruff", "server" },
				root_dir = python_root_dir,
				init_options = {},
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
				end,
			})
			vim.lsp.enable("ruff")

			-- Basic config & bindings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
