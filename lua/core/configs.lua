-- Basic editor's view
vim.wo.number = true
vim.wo.relativenumber = true

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Copy & Paste
vim.opt.clipboard = "unnamedplus"

-- Indent
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Editor
vim.opt.fillchars = {
	vert = "│",
	fold = "⠀",
	eob = " ",
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}

-- etc
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true

-- fix for recent projects update
do
	local ok, utils = pcall(require, "dashboard.utils")
	if not ok then
		return
	end

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			local cwd = vim.loop.cwd()
			if not cwd or cwd == "" then
				return
			end

			local cache_dir = utils.path_join(vim.fn.stdpath("cache"), "dashboard")
			local cache_path = utils.path_join(cache_dir, "cache")

			vim.fn.mkdir(cache_dir, "p")

			local projects = utils.read_project_cache(cache_path) or {}

			local cleaned = {}
			for _, p in ipairs(projects) do
				if p ~= cwd then
					table.insert(cleaned, p)
				end
			end

			table.insert(cleaned, 1, cwd)

			local limit = 50
			while #cleaned > limit do
				table.remove(cleaned)
			end

			vim.fn.writefile({ "return " .. vim.inspect(cleaned) }, cache_path)
		end,
	})
end
