local cmp = {}

--- highlight pattern
-- This has three parts:
-- 1. the highlight group
-- 2. text content
-- 3. special sequence to restore highlight: %*
-- Example pattern: %#SomeHighlight#some-text%*
local hi_pattern = '%%#%s#%s%%*'

function _G._statusline_component(name)
  return cmp[name]()
end

function cmp.diagnostic_status()
  local status = ''

  local ignore_modes = {
    ['c'] = true,
    ['t'] = true,
  }

  local current_mode = vim.api.nvim_get_mode().mode

  if ignore_modes[current_mode] then
    return status
  end

  local severity_levels = vim.diagnostic.severity

  local error_count = #vim.diagnostic.get(0, { severity = severity_levels.ERROR })
  local warning_count = #vim.diagnostic.get(0, { severity = severity_levels.WARN })
  local hint_count = #vim.diagnostic.get(0, { severity = severity_levels.HINT })

  if error_count > 0 then
    status = status .. ' E' .. error_count
  end
  if warning_count > 0 then
    status = status .. ' W' .. warning_count
  end
  if hint_count > 0 then
    status = status .. ' H' .. hint_count
  end

  if status ~= '' then
    return status .. ' '
  end

  return status
end

function cmp.position()
  return hi_pattern:format('Search', ' %3l:%-2c ')
end

function cmp.git_branch()
  local success, branch = pcall(vim.api.nvim_buf_get_var, 0, 'minigit_summary_string')
  branch = success and branch or ''

  if branch ~= '' then
    return '<' .. branch .. '> '
  end

  return branch
end

local statusline = {
  '%{%v:lua._statusline_component("diagnostic_status")%}',
  '%f',
  '%r',
  '%m',
  ' %{%v:lua._statusline_component("git_branch")%}',
  '%=',
  '%{&filetype} ',
  ' %2p%% ',
  '%{%v:lua._statusline_component("position")%}',
}

vim.o.statusline = table.concat(statusline, '')
