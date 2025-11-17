local function lualine_cur_line_diag()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = line })
  if #diags == 0 then
    return ""
  end

  -- берём наиболее серьёзную диагностику на этой строке
  table.sort(diags, function(a, b)
    return a.severity < b.severity
  end)

  local d = diags[1]
  local sev = vim.diagnostic.severity

  local icons = {
    [sev.ERROR] = "",
    [sev.WARN]  = "",
    [sev.INFO]  = "",
    [sev.HINT]  = "",
  }

  local hl = {
    [sev.ERROR] = "DiagnosticError",
    [sev.WARN]  = "DiagnosticWarn",
    [sev.INFO]  = "DiagnosticInfo",
    [sev.HINT]  = "DiagnosticHint",
  }

  local icon = icons[d.severity] or ""
  local group = hl[d.severity] or "Normal"
  local msg = (d.message or ""):gsub("\n", " ")

  return string.format("%%#%s# %s %s %%*", group, icon, msg)
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true
                },
                sections = {
                    lualine_c = {
                        -- 'filename',
                        lualine_cur_line_diag
                    },
                },
            })
        end
    }
}
