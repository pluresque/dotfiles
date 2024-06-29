
-- Define a table to hold the plugin functions
local SessionManager = {}

-- Check if session should be saved
local function should_save_session()
  local cwd = vim.fn.getcwd()
  -- Do not save if in root or home directory
  if cwd == '/' or cwd == vim.fn.expand '~' then
    return false
  end
  -- Do not save if only one file is open
  if #vim.fn.getbufinfo { buflisted = 1 } <= 1 then
    return false
  end
  return true
end

function SessionManager.setup()
  -- Create commands to save, load, delete, and list sessions
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

-- Function to get the default session directory
local function get_session_directory()
  return vim.fn.stdpath 'data' .. '/sessions/'
end

-- Ensure the session directory exists
local function ensure_session_directory()
  local session_dir = get_session_directory()
  if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, 'p')
  end
end

-- Sanitize the session name to be a valid filename
local function sanitize_session_name(name)
  return name:gsub('/', '__'):gsub(':', '_')
end

-- Generate a session name from the full current working directory path
local function generate_session_name()
  local cwd = vim.fn.getcwd()
  local session_name = sanitize_session_name(cwd)
  if session_name == '' then
    return 'NoName_' .. os.date '%Y%m%d%H%M%S' -- Fallback if something goes wrong
  end
  return session_name
end

-- Save session with an automatically generated name
function SessionManager.save_session()
  ensure_session_directory()
  local session_name = generate_session_name()
  local session_file = get_session_directory() .. session_name .. '.vim'
  vim.cmd('silent mksession! ' .. session_file)
  -- print('Session saved to ' .. session_file)
end

-- Load session for the current working directory
function SessionManager.load_session()
  local session_name = generate_session_name()
  local session_file = get_session_directory() .. session_name .. '.vim'
  if vim.fn.filereadable(session_file) == 1 then
    -- vim.cmd 'silent! bufdo bwipeout' -- Close file explorer if it opened
    vim.cmd('silent source ' .. session_file)
    -- print('Session loaded from ' .. session_file)
  else
    print('Session file does not exist: ' .. session_file)
  end
end

-- Delete session with a given name
function SessionManager.delete_session(name)
  local session_file = get_session_directory() .. name .. '.vim'
  if vim.fn.delete(session_file) == 0 then
    print('Session deleted: ' .. session_file)
  else
    print('Failed to delete session: ' .. session_file)
  end
end

-- List available sessions
function SessionManager.list_sessions()
  ensure_session_directory()
  local session_dir = get_session_directory()
  local sessions = vim.fn.globpath(session_dir, '*.vim', 0, 1)
  print 'Available sessions:'
  for _, session in ipairs(sessions) do
    print(vim.fn.fnamemodify(session, ':t:r'))
  end
end

SessionManager.setup()

-- Return the SessionManager table to make the functions accessible
return SessionManager
