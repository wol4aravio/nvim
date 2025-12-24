local M = {}

local uv = vim.uv or vim.loop
local sep = package.config:sub(1, 1)

local cache = {}

local function is_windows()
	return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

local function path_join(...)
	local parts = { ... }
	return table.concat(parts, sep)
end

local function exists(path)
	return path and uv.fs_stat(path) ~= nil
end

local function venv_python(venv_path)
	if is_windows() then
		return path_join(venv_path, "Scripts", "python.exe")
	end
	return path_join(venv_path, "bin", "python")
end

local function read_file(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok or not lines then
		return nil
	end
	return table.concat(lines, "\n")
end

local function is_poetry_project(workspace)
	local pyproject = path_join(workspace, "pyproject.toml")
	if not exists(pyproject) then
		return false
	end
	if exists(path_join(workspace, "poetry.lock")) then
		return true
	end
	local text = read_file(pyproject)
	if not text then
		return false
	end

	if text:find("[tool.poetry]", 1, true) then
		return true
	end
	return false
end

local function find_poetry_exe()
	local exe = vim.fn.exepath("poetry")
	if exe ~= "" and exists(exe) then
		return exe
	end

	local candidates = {
		vim.fn.expand("~/.local/bin/poetry"),
		vim.fn.expand("~/.poetry/bin/poetry"),
		vim.fn.expand("~/Library/Application Support/pypoetry/venv/bin/poetry"),
		"/opt/homebrew/bin/poetry",
		"/usr/local/bin/poetry",
	}

	for _, p in ipairs(candidates) do
		if exists(p) then
			return p
		end
	end
	return nil
end

local function find_project_venv(workspace)
	local candidates = { ".venv", "venv", ".env", "env" }
	for _, dir in ipairs(candidates) do
		local venv = path_join(workspace, dir)
		local python = venv_python(venv)
		if exists(python) then
			return python
		end
	end
	return nil
end

local function run_cmd(cmd, cwd, timeout_ms)
	-- Neovim 0.10+: vim.system
	if vim.system then
		local ok, result = pcall(function()
			return vim.system(cmd, { cwd = cwd, text = true }):wait(timeout_ms or 5000)
		end)
		if not ok or not result or result.code ~= 0 then
			return nil
		end
		return vim.trim(result.stdout or "")
	end

	-- Fallback
	local out = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return vim.trim(out or "")
end

local function find_poetry_venv(workspace)
	if not is_poetry_project(workspace) then
		return nil
	end

	local poetry = find_poetry_exe()
	if not poetry then
		return nil
	end

	local venv = run_cmd({ poetry, "env", "info", "-p" }, workspace, 8000)
	if not venv or venv == "" then
		local list = run_cmd({ poetry, "env", "list", "--full-path" }, workspace, 8000)
		if not list or list == "" then
			return nil
		end
		venv = list:match("([^\n ]+)")
	end

	if not venv or venv == "" then
		return nil
	end

	local python = venv_python(venv)
	if exists(python) then
		return python
	end
	return nil
end

---@param workspace string?
---@return string
function M.get_python_path(workspace)
	workspace = workspace or vim.fn.getcwd()

	if cache[workspace] then
		return cache[workspace]
	end

	local python = find_project_venv(workspace)
	if python then
		cache[workspace] = python
		return python
	end

	python = find_poetry_venv(workspace)
	if python then
		cache[workspace] = python
		return python
	end

	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" then
		python = venv_python(venv)
		if exists(python) then
			cache[workspace] = python
			return python
		end
	end

	python = vim.fn.exepath("python3")
	if python == "" then
		python = vim.fn.exepath("python")
	end
	if python == "" then
		python = "python3"
	end

	cache[workspace] = python
	return python
end

function M.clear_cache()
	cache = {}
end

return M
