return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		local function cache_file()
			return vim.fn.stdpath("cache") .. "/dashboard/cache"
		end

		local function read_projects()
			local path = cache_file()
			local fd = io.open(path, "r")
			if not fd then
				return {}
			end

			local data = fd:read("*a")
			fd:close()

			if not data or data == "" then
				return {}
			end

			local ok, chunk = pcall(loadstring, data)
			if not ok or not chunk then
				return {}
			end

			local ok_list, list = pcall(chunk)
			if not ok_list or type(list) ~= "table" then
				return {}
			end

			return list
		end

		local function write_projects(list)
			local path = cache_file()
			vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

			local fd = assert(io.open(path, "w"))
			fd:write("return " .. vim.inspect(list))
			fd:close()
		end

		local function current_project_dir()
			return vim.fs.normalize(vim.fn.getcwd())
		end

		local function save_project(dir)
			dir = dir or current_project_dir()

			if not dir or dir == "" or vim.fn.isdirectory(dir) ~= 1 then
				return
			end

			local list = vim.tbl_filter(function(item)
				return item ~= dir
			end, read_projects())

			table.insert(list, dir)

			local max_items = 20
			if #list > max_items then
				list = vim.list_slice(list, #list - max_items + 1, #list)
			end

			write_projects(list)
		end

		-- чтобы папка, из которой ты запустил nvim, сразу попадала в cache
		save_project()

		local group = vim.api.nvim_create_augroup("DashboardRecentProjects", { clear = true })

		vim.api.nvim_create_autocmd({ "DirChanged", "VimLeavePre" }, {
			group = group,
			callback = function()
				save_project()
			end,
		})

		require("dashboard").setup({
			theme = "hyper",
			config = {
				week_header = { enable = true },
				project = {
					enable = true,
					limit = 7,
					action = function(path)
						require("telescope.builtin").find_files({ cwd = path })
					end,
				},
				mru = { enable = false },
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{ desc = "󰩈 Quit", group = "@property", action = "q", key = "q" },
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
