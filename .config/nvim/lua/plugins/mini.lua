return {
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<c-e>',
        function()
          local MiniFiles = require 'mini.files'
          local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          vim.defer_fn(function()
            MiniFiles.reveal_cwd()
          end, 30)
        end,
      },
    },
    config = function()
      -- Better Around/Inside textobjects
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require('mini.bufremove').setup()
      require('mini.bracketed').setup()
      require('mini.diff').setup()
      require('mini.git').setup()

      local hipatterns = require 'mini.hipatterns'

      hipatterns.setup {
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      local miniicons = require 'mini.icons'
      miniicons.setup { style = 'glyph' }
      miniicons.mock_nvim_web_devicons()

      -- File explorer
      require('mini.files').setup {
        content = {
          filter = function(entry)
            return entry.name ~= '.DS_Store' and entry.name ~= '.git' and entry.name ~= 'node_modules'
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
    end,
  },
}
