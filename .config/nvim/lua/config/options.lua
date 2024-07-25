vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus' -- Sync clipboard with system clipboard
vim.o.mouse = 'a' -- Enable mouse support in all modes

vim.o.sessionoptions = 'buffers,curdir,tabpages,winsize,folds'

-- Folds
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldopen = ''

-- Search and Highlighting
vim.o.hlsearch = true -- Stop highlighting matches after search is done
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to override)
vim.o.incsearch = true -- Show search results incrementally as you type
vim.o.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase
vim.o.infercase = true -- Adjust case of completion based on surrounding text
vim.o.inccommand = 'split' -- Preview substitutions in a split window

-- Line Numbers and Sign Columns
vim.o.number = true -- Show absolute line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.numberwidth = 4 -- Set the width of the line number column
vim.o.signcolumn = 'yes:1' -- Show signs in the number column

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
vim.o.showtabline = 2 -- Always show tabline
vim.o.laststatus = 3 -- Global status line
vim.o.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.o.shortmess = vim.o.shortmess .. 'I' -- Avoid showing the intro message
vim.o.showmode = false -- Don't display mode (e.g., -- INSERT --)

-- Files and Backups
vim.o.swapfile = false -- Disable swap file creation
vim.o.undofile = true -- Enable persistent undo

-- Soft wrapping
vim.o.wrap = true
vim.o.showbreak = '↪ '

-- Completion
vim.o.completeopt = 'menu,menuone,noselect,popup' -- Customize completion options

-- International Input
vim.o.iminsert = 0 -- Disable IME (Input Method Editor) in insert mode

vim.o.showtabline = 0

-- Diagnostics
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = true,
}

-- Undotree
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = 50
vim.g.undotree_HelpLine = 0

-- Floaterm
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8

-- Filetypes
vim.filetype.add {
  pattern = {
    ['.*/.github/workflows/.*%.yml'] = 'yaml.ghaction',
    ['.*/.github/workflows/.*%.yaml'] = 'yaml.ghaction',
    -- ['.*/Dockerfile.*'] = 'yaml.dockerfile',
    -- ['.*/.*%.Dockerfile'] = 'yaml.dockerfile',
  },
}

if vim.g.neovide then
  vim.o.guifont = 'JetBrainsMono Nerd Font:h14'
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_show_border = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_show_border = false
end