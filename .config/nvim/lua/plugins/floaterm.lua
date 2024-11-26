return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    lazy = true,
    cmd = {'ToggleTerm', 'TermExec', 'TermSelect'},
    keys = {
      {
        [[<c-\>]],
        function()
          require('toggleterm').toggle()
        end,
        { desc = 'Toggle terminal' },
      },
      {
        '<leader>td',
        function()
          local Terminal = require('toggleterm.terminal').Terminal
          local lazydocker = Terminal:new { cmd = 'lazydocker', displayname='docker', hidden = true, count = 5, direction = 'float' }
          lazydocker:toggle()
        end,
        { desc = 'Toggle lazydoker' },
      },
      {
        '<leader>tkb',
        function ()
          local Terminal = require('toggleterm.terminal').Terminal
          local lazyk9s = Terminal:new { cmd = 'k9s', hidden = true, count = 6 }
          lazyk9s:toggle()
        end,
        { desc = 'Toggle k9s' },
      },
    },
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
          title_pos = 'left',
        },
        winbar = {
          enabled = true,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end,
        },
      }
    end,
  },
}
