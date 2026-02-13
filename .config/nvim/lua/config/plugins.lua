vim.pack.add({
  { src = "https://github.com/sainnhe/gruvbox-material", name = "gruvbox-material" },
  { src = "https://github.com/echasnovski/mini.nvim",    name = "mini" },
  -- { src = "https://github.com/mbbill/undotree", name = "undotree" },
  -- { src = "https://github.com/wakatime/vim-wakatime",    name = "vim-wakatime" },
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  -- { src = "https://github.com/NeogitOrg/neogit", name = "neogit" },
  -- { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" },
  -- { src = "https://github.com/sindrets/diffview.nvim", name = "diffview" },
  -- { src = "https://github.com/saghen/blink.cmp", name = "blink-cmp" },
  -- { src = "https://github.com/rafamadriz/friendly-snippets", name = "friendly-snippets" },
  -- { src = "https://github.com/folke/flash.nvim", name = "flash" }
  -- { src = "https://github.com/stevearc/aerial.nvim",     name = "aerial" }
})

-- require('aerial').setup {
--   on_attach = function(bufnr)
--     vim.keymap.set('n', '_', '<cmd>AerialPrev<CR>', { buffer = bufnr })
--     vim.keymap.set('n', '+', '<cmd>AerialNext<CR>', { buffer = bufnr })
--   end,
-- }
-- vim.keymap.set('n', '<leader>ta', vim.cmd.AerialToggle)

vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'hard'
vim.cmd.colorscheme('gruvbox-material')

-- Neogit configuration
-- require('neogit').setup {
--   disable_hint = false,
--   disable_context_highlighting = false,
--   disable_signs = false,
--   disable_insert_on_commit = 'auto',
-- }
--
-- vim.keymap.set({'n'}, '<leader>g', function()
--   vim.cmd 'Neogit'
-- end, { desc = 'Neogit' })

-- Undotree configurationa
-- require('undotree').setup()
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = 50
vim.g.undotree_HelpLine = 0
vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle)

-- Mini.nvim configuration
vim.keymap.set('n', '<c-e>', function()
  local MiniFiles = require 'mini.files'
  local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function()
    MiniFiles.reveal_cwd()
  end, 30)
end)

-- Better Around/Inside textobjects
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
require('mini.surround').setup()

-- Better buffer management
require('mini.bufremove').setup()

-- Bracket navigation
require('mini.bracketed').setup()

-- Git integration
require('mini.git').setup()
require('mini.diff').setup()

-- Notifications
require('mini.notify').setup({
  window = {
    config = {
      border = 'none',
    },
  },
})

-- Highlight FIXME and TODO in comments, as well as hex colors
local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

-- Icons
local miniicons = require 'mini.icons'
miniicons.setup { style = 'glyph' }
miniicons.mock_nvim_web_devicons()

-- File explorer
require('mini.files').setup {
  content = {
    filter = function(entry)
      return entry.name ~= '.DS_Store' and entry.name ~= '.git' and entry.name ~= 'node_modules' and
      entry.name ~= '__pycache__'
    end,
  },
  mappings = {
    close = '<esc>',
    go_in = '<right>',
    go_in_plus = 'L',
    go_out = '<left>',
    go_out_plus = 'H',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 30,
    width_nofocus = 15,
    width_preview = 65,
  },
}


-- Flash configuration
-- require('flash').setup({
--   modes = {
--     search = {
--       enabled = false,
--     },
--   },
-- })

-- vim.keymap.set({ 'n', 'x', 'o' }, '<Enter>', function()
--   require('flash').jump()
-- end, { desc = 'Flash' })
--
-- vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
--   require('flash').treesitter()
-- end, { desc = 'Flash Treesitter' })
--

-- Blink.cmp configuration
-- require('blink.cmp').setup({
--   keymap = { preset = 'super-tab' },
--
--   appearance = {
--     use_nvim_cmp_as_default = true,
--     nerd_font_variant = 'mono',
--   },
--
--   sources = {
--     default = { 'lsp', 'path', 'snippets' },
--   },
--
--   signature = { enabled = true },
--   completion = {
--     documentation = { auto_show = true, auto_show_delay_ms = 500 },
--   },
-- })
