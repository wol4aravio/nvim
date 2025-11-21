-- local configs
require("core.configs")
require("core.mappings")

-- external plugins
require("core.lazy")

-- local editor settings
vim.opt.signcolumn = "yes"

-- Autostart
-- Filetypes
vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})
