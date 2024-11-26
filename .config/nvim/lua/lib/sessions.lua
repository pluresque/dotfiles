local SessionManager = {}

local function should_save_session()
  local cwd = vim.fn.getcwd()
  if cwd == '/' or cwd == vim.fn.expand '~' then
    return false
  end
  if #vim.fn.getbufinfo { buflisted = 1 } <= 1 then
    return false
  end
  return true
end

function SessionManager.setup()
  vim.api.nvim_create_user_command('SaveSession', function()
    SessionManager.save_session()
  end, {})

  vim.api.nvim_create_user_command('LoadSession', function()
    SessionManager.load_session()
  end, {})

  vim.api.nvim_create_user_command('DeleteSession', function(args)
    SessionManager.delete_session(args.args)
  end, { nargs = 1 })

  vim.api.nvim_create_user_command('ListSessions', function()
    SessionManager.list_sessions()
  end, {})

  local group_id = vim.api.nvim_create_augroup('SessionAutosave', { clear = true })
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group_id,
    callback = function()
      if should_save_session() then
        SessionManager.save_session()
      end
    end,
  })
end

local function get_session_directory()
  return vim.fn.stdpath 'data' .. '/sessions/'
end

local function ensure_session_directory()
  local session_dir = get_session_directory()
  if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, 'p')
  end
end

local function sanitize_session_name(name)
  return name:gsub('/', '__'):gsub(':', '_')
end

local function generate_session_name()
  local cwd = vim.fn.getcwd()
  local session_name = sanitize_session_name(cwd)
  if session_name == '' then
    return 'NoName_' .. os.date '%Y%m%d%H%M%S' -- Fallback if something goes wrong
  end
  return session_name
end

function SessionManager.save_session()
  ensure_session_directory()
  local session_name = generate_session_name()
  local session_file = get_session_directory() .. session_name .. '.vim'
  vim.cmd('silent mksession! ' .. session_file)
end

function SessionManager.load_session()
  local session_name = generate_session_name()
  local session_file = get_session_directory() .. session_name .. '.vim'
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd('silent source ' .. session_file)
  else
    print('Session file does not exist: ' .. session_file)
  end
end

function SessionManager.delete_session(name)
  local session_file = get_session_directory() .. name .. '.vim'
  if vim.fn.delete(session_file) == 0 then
    print('Session deleted: ' .. session_file)
  else
    print('Failed to delete session: ' .. session_file)
  end
end

function SessionManager.list_sessions()
  ensure_session_directory()
  local session_dir = get_session_directory()
  local sessions = vim.fn.globpath(session_dir, '*.vim', 0, 1)

  local lines = { 'Available sessions:' }
  for _, session in ipairs(sessions) do
    table.insert(lines, vim.fn.fnamemodify(session, ':t:r'))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 60
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
end

SessionManager.setup()

return SessionManager
