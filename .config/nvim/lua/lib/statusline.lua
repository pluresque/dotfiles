local StatusLine = {}
local H = {}

H.colors = require('catppuccin.palettes').get_palette()

StatusLine.config = {
  diagnostic_levels = {
    { name = 'ERROR', sign = 'E' },
    { name = 'WARN', sign = 'W' },
    { name = 'HINT', sign = 'H' },
    { name = 'INFO', sign = 'I' },
  },
  highlight = {
    { name = 'StatuslineModeNormal', data = { fg = H.colors.blue, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineModeInsert', data = { fg = H.colors.teal, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineModeVisual', data = { fg = H.colors.lavender, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineModeReplace', data = { fg = H.colors.flamingo, bg = H.colors.mantle, bold = true } },
    { name = 'StatusLineModeCommand', data = { fg = H.colors.peach, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineModeOther', data = { fg = H.colors.mauve, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineFileinfo', data = { fg = H.colors.overlay0, bg = H.colors.mantle } },
    { name = 'StatuslineGitInfo', data = { fg = H.colors.flamingo, bg = H.colors.mantle, bold = true } },
    { name = 'StatuslineLSP', data = { bg = H.colors.mantle, fg = H.colors.subtext1, bold = true } },
  },
  icons = {
    ['LSP'] = '',
    ['GIT'] = '',
  },
}

StatusLine.lsp_clients_per_buffer = {}

StatusLine.setup = function()
  _G.StatusLine = StatusLine
  -- StatusLine.has_devicons, StatusLine.devicons = pcall(require, 'nvim-web-devicons')

  local augroup = vim.api.nvim_create_augroup('StatusLine', {})
  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = augroup, pattern = pattern, callback = callback, desc = desc })
  end

  au({ 'WinEnter', 'BufWinEnter' }, '*', H.ensure_content, 'Ensure statusline content')

  local update_git_branch = function()
    -- local head = vim.fn.system('git symbolic-ref --short HEAD 2>/dev/null'):gsub('\n$', '')
    vim.api.nvim_buf_set_var(0, 'git_branch', 'main')
  end

  local update_lsp_clients = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local clients = {}
      for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
        table.insert(clients, client.name)
      end
      -- Assign the list of active clients to the buffer number
      StatusLine.lsp_clients_per_buffer[bufnr] = clients
    end
  end

  au({ 'BufReadPost', 'BufWritePost' }, '*', update_git_branch, 'Update current git branch for buffer')
  au({ 'LspAttach', 'LspDetach' }, '*', update_lsp_clients, 'Update active lsp clients')

  -- - Disable built-in statusline in Quickfix window
  vim.g.qf_disable_statusline = 1
  vim.go.statusline = '%{%v:lua.StatusLine.active()%}'

  -- Create default highlighting
  for _, statusline_data in ipairs(StatusLine.config.highlight) do
    statusline_data.data.default = true
    vim.api.nvim_set_hl(0, statusline_data.name, statusline_data.data)
  end
end

--- Combine groups of sections
--- Each group can be either a string or a table with fields `hl` (group's
--- highlight group) and `strings` (strings representing sections).
--- General idea of this function is as follows;
--- - String group is used as is (useful for special strings like `%<` or `%=`).
--- - Each table group has own highlighting in `hl` field (if missing, the
---   previous one is used) and string parts in `strings` field. Non-empty
---   strings from `strings` are separated by one space. Non-empty groups are
---   separated by two spaces (one for each highlighting).
StatusLine.combine_groups = function(groups)
  local parts = vim.tbl_map(function(s)
    if type(s) == 'string' then
      return s
    end
    if type(s) ~= 'table' then
      return ''
    end

    local string_arr = vim.tbl_filter(function(x)
      return type(x) == 'string' and x ~= ''
    end, s.strings or {})
    local str = table.concat(string_arr, ' ')

    -- Use previous highlight group
    if s.hl == nil then
      return ('%s'):format(str)
    end

    -- Allow using this highlight group later
    if str:len() == 0 then
      return string.format('%%#%s#', s.hl)
    end

    return string.format('%%#%s# %s ', s.hl, str)
  end, groups)

  return table.concat(parts, '')
end

StatusLine.section_git = function()
  local s, v = pcall(function()
    return StatusLine.config.icons.GIT .. ' ' .. vim.api.nvim_buf_get_var(0, 'git_branch') .. ' ▌'
  end)
  if s then
    return v
  end
  return ''
end

StatusLine.section_lsp = function()
  local servers = StatusLine.lsp_clients_per_buffer[vim.fn.bufnr '%']
  if servers then
    return ' '.. string.format('%s', table.concat(servers, ''))
  else
    return ''
  end
end

StatusLine.section_diagnostics = function()
  if H.isnt_normal_buffer() or H.has_no_lsp_attached() or H.diagnostic_is_disabled() then
    return ''
  end

  -- Construct string parts
  local count = H.diagnostic_get_count()
  local severity, t = vim.diagnostic.severity, {}
  for _, level in pairs(StatusLine.config.diagnostic_levels) do
    local n = count[severity[level.name]] or 0
    -- Add level info only if diagnostic is present
    if n > 0 then
      table.insert(t, string.format('%s%s', level.sign, n))
    end
  end
  if vim.tbl_count(t) == 0 then
    return ''
  end

  return string.format('%s', table.concat(t, ' '))
end

StatusLine.section_filename = function()
  if vim.bo.buftype == 'terminal' then
    return ''
  end

  return '%f' .. (vim.bo.modified and ' + ' or '') .. (vim.bo.readonly and ' (RO) ' or '')
end

-- StatusLine.section_fileinfo_icon = function()
--   local extension = vim.fn.expand '%:e'
--   local icon, icon_color = StatusLine.devicons.get_icon_color(vim.fn.expand '%:t', extension, { default = false })
--   if vim.fn.hlexists(extension) == 0 then
--     vim.api.nvim_set_hl(0, extension, { fg = icon_color, bg = H.colors.mantle })
--   end
--   return icon, extension
-- end

--- Section for file information
StatusLine.section_fileinfo = function()
  local fileformat = 'CRLF'
  local fmt = vim.bo.fileformat
  if fmt == 'unix' then
    fileformat = 'LF'
  elseif fmt == 'mac' then
    fileformat = 'CR'
  end
  local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
  local indent_type = vim.api.nvim_get_option_value('expandtab', { scope = 'local' }) and 'Spaces:' or 'Tab Size:'
  local indent_size = vim.api.nvim_get_option_value('tabstop', { scope = 'local' })

  return string.format('%s %s %s %s', fileformat, enc:upper(), indent_type, indent_size)
end

H.n_attached_lsp = {}

H.ensure_content = vim.schedule_wrap(function()
  local current_win = vim.api.nvim_get_current_win()
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win_id].statusline = (win_id == current_win or vim.o.laststatus == 3) and '%{%v:lua.StatusLine.active()%}' or '%{%v:lua.StatusLine.inactive()%}'
  end
end)

local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)

H.modes = setmetatable({
  ['n'] = { name = 'N', hl = 'StatuslineModeNormal' },
  ['v'] = { name = 'V', hl = 'StatuslineModeVisual' },
  ['V'] = { name = 'VL', hl = 'StatuslineModeVisual' },
  [CTRL_V] = { name = 'VB', hl = 'StatuslineModeVisual' },
  ['s'] = { name = 'SELECT', hl = 'StatuslineModeVisual' },
  ['S'] = { name = 'SELECT-LINE', hl = 'StatuslineModeVisual' },
  [CTRL_S] = { name = 'SELECT-BLOCK', hl = 'StatuslineModeVisual' },
  ['i'] = { name = 'I', hl = 'StatuslineModeInsert' },
  ['R'] = { name = 'REPLACE', hl = 'StatuslineModeReplace' },
  ['c'] = { name = 'C', hl = 'StatuslineModeCommand' },
  ['r'] = { name = 'OTHER', hl = 'StatuslineModeOther' },
  ['!'] = { name = 'SHELL', hl = 'StatuslineModeOther' },
  ['t'] = { name = 'TERM', hl = 'StatuslineModeOther' },
}, {
  __index = function()
    return { name = 'UNK', hl = '%#StatuslineModeOther#' }
  end,
})

StatusLine.active = function()
  local mode = H.modes[vim.fn.mode()]
  -- local icon, icon_color = StatusLine.section_fileinfo_icon()

  return StatusLine.combine_groups {
    { hl = mode.hl, strings = { string.format('▌ %s', mode.name) } },
    { hl = 'StatuslineFileinfo', strings = { StatusLine.section_diagnostics() } },
    '%<', -- Mark general truncate point
    -- { hl = icon_color, strings = { icon } },
    { hl = 'StatuslineFileinfo', strings = { StatusLine.section_filename() } },
    '%=', -- End left alignment
    { hl = 'StatuslineFileinfo', strings = { StatusLine.section_fileinfo() } },
    { hl = 'StatuslineFileinfo', strings = { '%l:%1v' } },
    { hl = 'StatuslineLSP', strings = { StatusLine.section_lsp() } },
    { hl = 'StatusLineGitInfo', strings = { StatusLine.section_git() } },
  }
end

StatusLine.inactive = function()
  return '%#StatuslineInactive#%F%='
end

H.isnt_normal_buffer = function()
  return vim.bo.buftype ~= ''
end

H.has_no_lsp_attached = function()
  return #vim.lsp.get_clients { bufnr = 0 } == 0
end

H.diagnostic_get_count = function()
  return vim.diagnostic.count(0)
end

H.diagnostic_is_disabled = function()
  return not vim.diagnostic.is_enabled { bufnr = 0 }
end

StatusLine.setup()

return StatusLine
