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

local function find_poetry_venv(workspace)
	if not exists(path_join(workspace, "poetry.lock")) then
		return nil
	end
	if vim.fn.executable("poetry") ~= 1 then
		return nil
	end

	local ok, result = pcall(function()
		return vim.system({ "poetry", "env", "info", "-p" }, { cwd = workspace, text = true }):wait(1500)
	end)
	if not ok or not result or result.code ~= 0 then
		return nil
	end

	local venv = vim.trim(result.stdout or "")
	if venv == "" then
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
