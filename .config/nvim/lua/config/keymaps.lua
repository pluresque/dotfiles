local m = vim.keymap.set

-- Navigation with wrapped lines
m({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Move down (wrap-aware)', silent = true })
m({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Move up (wrap-aware)', silent = true })

-- Centered searching
m('n', 'n', 'nzzzv', { desc = 'Search next and center', silent = true })
m('n', 'N', 'Nzzzv', { desc = 'Search previous and center', silent = true })

-- Word navigation
m('n', 'q', 'b', { desc = 'Go to previous word (start)', noremap = true, silent = true })
m('n', 'Q', 'B', { desc = 'Go to previous WORD (ignoring punctuation)', noremap = true, silent = true })

-- Word deletion
m('n', '<BS>', 'ciw', { desc = 'Change inner word (delete word)', silent = true, noremap = true })

-- Clear search highlights
m('n', '<esc>', '<cmd>noh<cr>', { desc = 'Clear search highlight', silent = true, noremap = true })

-- Better indenting
m('v', '<', '<gv', { desc = 'Indent line left', silent = true, noremap = true })
m('v', '>', '>gv', { desc = 'Indent line right', silent = true, noremap = true })
m('n', '<S-Right>', '>>', { desc = 'Indent current line', silent = true, noremap = true })
m('v', '<S-Right>', '>gv', { desc = 'Indent selected block', silent = true, noremap = true })
m('n', '<S-Left>', '<<', { desc = 'De-indent current line', silent = true, noremap = true })
m('v', '<S-Left>', '<gv', { desc = 'De-indent selected block', silent = true, noremap = true })

-- File management
m({ 'i', 'x', 'n', 's' }, '<C-q>', '<cmd>qa<cr><esc>', { desc = 'Quit Neovim', silent = true, noremap = true })
m({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>wa<cr><esc>', { desc = 'Save all files', silent = true, noremap = true })

-- Select all
m('n', '<C-a>', 'ggVG', { desc = 'Select all text', silent = true, noremap = true })
m('i', '<C-a>', '<esc>ggVG', { desc = 'Select all text', silent = true, noremap = true })

-- Move lines up/down
m('v', '<S-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true, noremap = true })
m('v', '<S-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true, noremap = true })
m('n', '<S-Up>', ':m .-2<CR>==', { desc = 'Move line up', silent = true, noremap = true })
m('n', '<S-Down>', ':m .+1<CR>==', { desc = 'Move line down', silent = true, noremap = true })

-- Buffers
m('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete current buffer', silent = true, noremap = true })
m('n', '<leader>ив', '<cmd>bd<cr>', { desc = 'Delete current buffer', silent = true, noremap = true })

-- Window resizing
m('n', '<C-S-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height', silent = true, noremap = true })
m('n', '<C-S-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height', silent = true, noremap = true })
m('n', '<C-S-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width', silent = true, noremap = true })
m('n', '<C-S-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width', silent = true, noremap = true })

-- Sessions
m('n', '<leader>ts', '<cmd>LoadSession<cr>', { desc = 'Load session', silent = true, noremap = true })
m('n', '<leader>еі', '<cmd>LoadSession<cr>', { desc = 'Load session', silent = true, noremap = true })

-- Diagnostics
m('n', 'xo', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>', {
  desc = 'Show diagnostics in floating window',
  silent = true,
  noremap = true,
})

vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })

m('n', '<Leader>q', function()
  vim.diagnostic.setloclist { open = false }
  -- local window = vim.api.nvim_get_current_win()
  vim.cmd.lwindow()
  -- vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
end, { buffer = bufnr })
