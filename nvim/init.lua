vim.loader.enable()

require 'config.options'
require 'config.keymaps'
require 'lib.sessions'
require 'config.autocmds'
require 'config.plugins'

vim.api.nvim_create_user_command('Float', function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.5),
    height = math.floor(vim.o.lines * 0.5),
    row = math.floor(vim.o.lines * 0.25),
    col = math.floor(vim.o.columns * 0.25),
    style = 'minimal',
    border = 'rounded'
  })
end, {})
