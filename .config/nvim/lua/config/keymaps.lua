local m = vim.keymap.set

-- Up/Down with wrap
m({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Down', silent = true })
m({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Up', silent = true })

-- Centered searching
m('n', 'n', 'nzzzv', { desc = 'Search Next', silent = true })
m('n', 'N', 'Nzzzv', { desc = 'Search Previous', silent = true })

m('n', 'q', 'b', { noremap = true, desc = 'Go to previous word (start)' })
m('n', 'Q', 'B', { noremap = true, desc = 'Go to previous word (start, ignoring punctuation)' })

-- Jump half pages
m('n', '=', '<C-u>zz', { noremap = true, silent = true, desc = 'Page up' })
m('n', '-', '<C-d>zz', { noremap = true, silent = true, desc = 'Page down' })

m('n', '<BS>', 'ciw', { desc = 'Delete word' })

m('n', '<esc>', '<cmd>noh<cr>', { desc = 'Clear search highlight', silent = true })

-- Better indenting
m('v', '<', '<gv', { desc = 'Indent Line Left' })
m('v', '>', '>gv', { desc = 'Indent Line Right' })
m('n', '<S-Right>', '>>', { desc = 'Indent line.' })
m('v', '<S-Right>', '>gv', { desc = 'Indent block.', silent = true, noremap = true })
m('n', '<S-Left>', '<<', { desc = 'Deindent line.' })
m('v', '<S-Left>', '<gv', { desc = 'Deindent block.', silent = true, noremap = true })

m({ 'i', 'x', 'n', 's' }, '<C-q>', '<cmd>qa<cr><esc>', { desc = 'Quit', silent = true })
m({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>wa<cr><esc>', { desc = 'Save Files', silent = true })

m({ 'n' }, '<C-a>', 'ggVG', { desc = 'Select all text' })
m({ 'i' }, '<C-a>', '<esc>ggVG', { desc = 'Select all text' })

m('v', '<S-Up>', ":m '<-2<CR>gv=gv")
m('v', '<S-Down>', ":m '>+1<CR>gv=gv")
m('n', '<S-Up>', ':m .-2<CR>==', { noremap = true, silent = true })
m('n', '<S-Down>', ':m .+1<CR>==', { noremap = true, silent = true })

--- Buffers
m({ 'n' }, '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete Buffer' })

--- Windows
m('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
m('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
m('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
m('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Resize window using <ctrl> arrow keys
m('n', '<C-S-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
m('n', '<C-S-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
m('n', '<C-S-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
m('n', '<C-S-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Explorer
m({ 'n', 'i' }, '<C-e>', [[<Cmd>lua MiniFiles.open()<CR>]], { silent = true, desc = 'Open File Explorer' })

-- Lazy
m('n', '<leader>tl', '<cmd>Lazy<cr>', { desc = 'Toggle Lazy' })

-- Sessions
m('n', '<leader>ts', '<cmd>LoadSession<cr>', { desc = 'Load Session' })

-- Terminal
m('t', '<esc>', '<cmd>close<cr>', { desc = 'Enter Normal Mode' })

-- Diagnostics
m('n', 'xo', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>', { noremap = true, remap = true })
