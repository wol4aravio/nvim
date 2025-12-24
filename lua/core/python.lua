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
	-- Не дергаем poetry без необходимости: сначала проверяем, что это реально poetry-проект.
	if not exists(path_join(workspace, "poetry.lock")) then
		return nil
	end
	if vim.fn.executable("poetry") ~= 1 then
		return nil
	end

	-- Важно: не блокируем Neovim надолго.
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

---Возвращает путь до Python-интерпретатора, который надо отдать Pyright'у.
---Поддерживает: standalone файлы, .venv/venv, uv, poetry, активированный VIRTUAL_ENV.
---@param workspace string?
---@return string
function M.get_python_path(workspace)
	workspace = workspace or vim.fn.getcwd()

	if cache[workspace] then
		return cache[workspace]
	end

	-- 1) Виртуалка в самом проекте (.venv/venv/…)
	local python = find_project_venv(workspace)
	if python then
		cache[workspace] = python
		return python
	end

	-- 2) Poetry (если виртуалка не в проекте)
	python = find_poetry_venv(workspace)
	if python then
		cache[workspace] = python
		return python
	end

	-- 3) Активированная виртуалка из окружения (например, если запускали nvim из `source .venv/bin/activate`)
	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" then
		python = venv_python(venv)
		if exists(python) then
			cache[workspace] = python
			return python
		end
	end

	-- 4) Системный python
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
