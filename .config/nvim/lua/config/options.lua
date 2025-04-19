vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus' -- Sync clipboard with system clipboard
vim.o.mouse = ''

vim.o.sessionoptions = 'buffers,curdir,tabpages,winsize,folds'

-- Folds
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldopen = ''
vim.o.foldtext = ''

-- Search and Highlighting
vim.o.hlsearch = true -- Stop highlighting matches after search is done
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to override)
vim.o.incsearch = true -- Show search results incrementally as you type
vim.o.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase
vim.o.infercase = true -- Adjust case of completion based on surrounding text
vim.o.inccommand = 'split' -- Preview substitutions in a split window

-- Line Numbers and Sign Columns
vim.o.number = true -- Show absolute line numbers
-- vim.o.relativenumber = true -- Show relative line numbers
vim.o.numberwidth = 4 -- Set the width of the line number column
vim.o.signcolumn = 'yes:1' -- Show signs in the number column
vim.o.cmdheight = 0
vim.o.cursorline = true

-- Scrolling and Viewport
vim.o.scrolloff = 10 -- Keep 10 lines visible above and below the cursor when scrolling
vim.o.smoothscroll = true

-- Tabs and Indentation
vim.o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.autoindent = true -- Copy indent from current line when starting a new line
vim.o.smartindent = true -- Smart autoindenting for new lines
vim.o.breakindent = true -- Preserve indent structure of wrapped lines

-- Splits and Windows
vim.o.splitbelow = true -- Split windows open below the current window
vim.o.splitright = true -- Split windows open to the right of the current window

-- User Interface
vim.o.showtabline = 1 -- Always show tabline
vim.o.laststatus = 3 -- Global status line
vim.o.termguicolors = true -- Enable 24-bit RGB color in the TUI

-- Files and Backups
vim.o.swapfile = false -- Disable swap file creation
vim.o.undofile = true -- Enable persistent undo

-- Soft wrapping
vim.o.wrap = true
vim.o.showbreak = '↪ '

-- Completion
vim.o.completeopt = 'menu,menuone,popup,noselect' -- Customize completion options
-- International Input
vim.o.iminsert = 0 -- Disable IME (Input Method Editor) in insert mode

-- Diagnostics
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = true,
}

-- Abbreviations
local command_abbrevs = {
  W = 'w',
  Wa = 'wa',
  WA = 'wa',
  wA = 'wa',
  wq = 'wq',
  Wq = 'wq',
  WQ = 'wq',
  wQ = 'wq',
  Q = 'q',
  qa = 'qa',
  Qa = 'qa',
  QA = 'qa',
  qA = 'qa',
  Wqa = 'wqa',
  WQa = 'wqa',
  WQA = 'wqa',
  wQa = 'wqa',
  wQA = 'wqa',
  wqA = 'wqa',
  H = 'h'
}

for lhs, rhs in pairs(command_abbrevs) do
  vim.cmd('cnoreabbrev ' .. lhs .. ' ' .. rhs)
end
